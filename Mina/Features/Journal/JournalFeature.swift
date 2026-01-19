import Foundation
import ComposableArchitecture
import SwiftData

// MARK: - Journal Feature
// Parent reducer for the Journal (Home) tab with inline editing

@Reducer
struct JournalFeature {
    
    // MARK: - Cancel IDs
    
    enum CancelID: Hashable {
        case recording
    }
    
    // MARK: - State
    
    @ObservableState
    struct State: Equatable {
        /// Today's journal entries
        var entries: IdentifiedArrayOf<JournalEntryState> = []
        
        /// Current streak count
        var streak: Int = 0
        
        /// Loading state
        var isLoading: Bool = false
        
        /// Error message if any
        var errorMessage: String?
        
        /// Scroll to top trigger
        var scrollToTopTrigger: Int = 0
        
        /// Inline editing state
        var isEditing: Bool = false
        var editorText: String = ""
        var editorFocused: Bool = false
        
        /// Entry being edited (nil = new entry)
        var editingEntryId: UUID? = nil
        
        /// Voice recording state
        var isRecording: Bool = false
        var recordingDuration: TimeInterval = 0
        var audioLevels: [CGFloat] = [] // For waveform visualization
        
        /// Child: Active input bar state
        var activeInput = ActiveInputFeature.State()
        
        /// Child: Entry detail (for viewing/editing existing from list)
        @Presents var entryDetail: EntryEditorFeature.State?
        
        /// Whether the user is actively typing
        var isTyping: Bool {
            isEditing && editorFocused
        }
        
        /// Placeholder text
        var placeholderText: String {
            "Start writing your thoughts..."
        }
    }
    
    // MARK: - Actions
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // Lifecycle
        case onAppear
        case onDisappear
        
        // Data loading
        case loadEntries
        case entriesLoaded([JournalEntry])
        case loadStreak
        case streakLoaded(Int)
        case loadFailed(String)
        
        // User interactions
        case entryTapped(JournalEntryState.ID)
        case deleteEntry(JournalEntryState.ID)
        case entryDeleted
        case scrollToTopTapped
        case settingsTapped
        
        // Inline editing
        case startEditing
        case cancelEditing
        case saveEntry
        case entrySaved
        case editorTextChanged(String)
        case setEditorFocus(Bool)
        
        // Keyboard accessory actions
        case micTapped
        case cameraTapped
        case attachTapped
        case dismissKeyboard
        
        // Voice recording actions
        case startRecording
        case stopRecording
        case cancelRecording
        case confirmRecording
        case recordingTick
        case audioLevelUpdated(CGFloat)
        case transcriptionReceived(String)
        
        // Child actions
        case entryDetail(PresentationAction<EntryEditorFeature.Action>)
        case activeInput(ActiveInputFeature.Action)
        
        // Legacy (for compatibility)
        case newEntryTapped
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.databaseClient) var database
    @Dependency(\.dateClient) var dateClient
    @Dependency(\.continuousClock) var clock
    
    // MARK: - Reducer
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.activeInput, action: \.activeInput) {
            ActiveInputFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            // MARK: Lifecycle
                
            case .onAppear:
                return .merge(
                    .send(.loadEntries),
                    .send(.loadStreak)
                )
                
            case .onDisappear:
                return .none
                
            // MARK: Data Loading
                
            case .loadEntries:
                state.isLoading = true
                return .run { send in
                    do {
                        let entries = try await database.fetchTodayEntries()
                        await send(.entriesLoaded(entries))
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                
            case let .entriesLoaded(entries):
                state.isLoading = false
                state.entries = IdentifiedArrayOf(
                    uniqueElements: entries.map { JournalEntryState(entry: $0) }
                )
                return .none
                
            case .loadStreak:
                return .run { send in
                    do {
                        let streak = try await database.calculateStreak()
                        await send(.streakLoaded(streak))
                    } catch {
                        await send(.streakLoaded(0))
                    }
                }
                
            case let .streakLoaded(streak):
                state.streak = streak
                return .none
                
            case let .loadFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            // MARK: User Interactions
                
            case let .entryTapped(id):
                guard let entryState = state.entries[id: id] else {
                    return .none
                }
                state.entryDetail = EntryEditorFeature.State(
                    mode: .editing(entryState.entry)
                )
                return .none
                
            case let .deleteEntry(id):
                guard let entryState = state.entries[id: id] else {
                    return .none
                }
                let entryId = entryState.entry.id
                return .run { send in
                    try await database.deleteEntry(entryId)
                    await send(.entryDeleted)
                }
                
            case .entryDeleted:
                return .send(.loadEntries)
                
            case .scrollToTopTapped:
                state.scrollToTopTrigger += 1
                return .none
                
            case .settingsTapped:
                // TODO: Navigate to settings
                return .none
                
            // MARK: Inline Editing
                
            case .startEditing, .newEntryTapped:
                state.isEditing = true
                state.editorText = ""
                state.editingEntryId = nil
                state.editorFocused = true
                return .none
                
            case .cancelEditing:
                state.isEditing = false
                state.editorText = ""
                state.editingEntryId = nil
                state.editorFocused = false
                return .none
                
            case .saveEntry:
                let content = state.editorText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !content.isEmpty else {
                    // Empty entry, just cancel
                    return .send(.cancelEditing)
                }
                
                let entryId = state.editingEntryId
                
                return .run { send in
                    do {
                        if let existingId = entryId {
                            // Update existing entry
                            try await database.updateEntryContent(existingId, content)
                        } else {
                            // Create new entry
                            let entry = JournalEntry(
                                title: "",
                                content: content
                            )
                            try await database.saveEntry(entry)
                        }
                        await send(.entrySaved)
                    } catch {
                        // Handle error
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                
            case .entrySaved:
                state.isEditing = false
                state.editorText = ""
                state.editingEntryId = nil
                state.editorFocused = false
                return .merge(
                    .send(.loadEntries),
                    .send(.loadStreak)
                )
                
            case let .editorTextChanged(text):
                state.editorText = text
                return .none
                
            case let .setEditorFocus(focused):
                state.editorFocused = focused
                if !focused && state.editorText.isEmpty {
                    // Lost focus with empty text, cancel editing
                    state.isEditing = false
                }
                return .none
                
            // MARK: Keyboard Accessory Actions
                
            case .micTapped:
                // Start voice recording
                return .send(.startRecording)
                
            case .cameraTapped:
                // TODO: Open camera
                return .none
                
            case .attachTapped:
                // TODO: Show attachment options
                return .none
                
            case .dismissKeyboard:
                // Save if there's content, otherwise cancel
                if state.editorText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return .send(.cancelEditing)
                } else {
                    return .send(.saveEntry)
                }
                
            // MARK: Voice Recording
                
            case .startRecording:
                state.isRecording = true
                state.recordingDuration = 0
                state.audioLevels = []
                // Generate initial random levels for visual effect
                for _ in 0..<30 {
                    state.audioLevels.append(CGFloat.random(in: 0.1...0.3))
                }
                // TODO: Start actual audio recording with AVAudioRecorder
                return .run { send in
                    // Simulate recording timer and audio levels
                    for await _ in self.clock.timer(interval: .milliseconds(100)) {
                        await send(.recordingTick)
                        // Simulate audio level changes
                        let level = CGFloat.random(in: 0.2...1.0)
                        await send(.audioLevelUpdated(level))
                    }
                }
                .cancellable(id: CancelID.recording, cancelInFlight: true)
                
            case .stopRecording:
                state.isRecording = false
                return .cancel(id: CancelID.recording)
                
            case .cancelRecording:
                state.isRecording = false
                state.recordingDuration = 0
                state.audioLevels = []
                return .cancel(id: CancelID.recording)
                
            case .confirmRecording:
                // Stop recording and process
                state.isRecording = false
                let duration = state.recordingDuration
                state.recordingDuration = 0
                state.audioLevels = []
                
                // TODO: Process recording with speech-to-text
                // For now, add a placeholder transcription
                return .merge(
                    .cancel(id: CancelID.recording),
                    .run { send in
                        // Simulate transcription delay
                        try await self.clock.sleep(for: .milliseconds(500))
                        // In real implementation, this would come from SFSpeechRecognizer
                        let placeholder = "[Voice note - \(Int(duration))s]"
                        await send(.transcriptionReceived(placeholder))
                    }
                )
                
            case .recordingTick:
                state.recordingDuration += 0.1
                return .none
                
            case let .audioLevelUpdated(level):
                // Shift levels and add new one for waveform animation
                if state.audioLevels.count >= 30 {
                    state.audioLevels.removeFirst()
                }
                state.audioLevels.append(level)
                return .none
                
            case let .transcriptionReceived(text):
                // Append transcribed text to editor
                if state.editorText.isEmpty {
                    state.editorText = text
                } else {
                    state.editorText += " " + text
                }
                return .none
                
            // MARK: Child Actions
                
            case .entryDetail(.presented(.saveCompleted)):
                state.entryDetail = nil
                return .send(.loadEntries)
                
            case .entryDetail(.presented(.cancelTapped)):
                state.entryDetail = nil
                return .none
                
            case .entryDetail:
                return .none
                
            case .activeInput(.startNewEntry):
                return .send(.startEditing)
                
            case .activeInput:
                return .none
            }
        }
        .ifLet(\.$entryDetail, action: \.entryDetail) {
            EntryEditorFeature()
        }
    }
}

// MARK: - Journal Entry State
// Wrapper for displaying entries in the list

struct JournalEntryState: Equatable, Identifiable {
    let id: UUID
    let entry: JournalEntry
    
    init(entry: JournalEntry) {
        self.id = entry.id
        self.entry = entry
    }
    
    static func == (lhs: JournalEntryState, rhs: JournalEntryState) -> Bool {
        lhs.id == rhs.id &&
        lhs.entry.title == rhs.entry.title &&
        lhs.entry.content == rhs.entry.content &&
        lhs.entry.updatedAt == rhs.entry.updatedAt
    }
}
