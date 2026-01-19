import SwiftUI
import ComposableArchitecture

// MARK: - Journal Tab View
// Main container view for the Journal (Home) tab with inline editing

struct JournalTabView: View {
    
    @Bindable var store: StoreOf<JournalFeature>
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.minaBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (always visible)
                JournalHeaderView(
                    streak: store.streak,
                    onLogoTap: { store.send(.scrollToTopTapped) },
                    onSettingsTap: { store.send(.settingsTapped) }
                )
                
                // Content area
                contentView
            }
            
            // Floating Input Bar (hidden when editing)
            if !store.isEditing {
                VStack {
                    Spacer()
                    FloatingInputBar {
                        store.send(.startEditing)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: isEditorFocused) { _, newValue in
            store.send(.setEditorFocus(newValue))
        }
        .onChange(of: store.editorFocused) { _, newValue in
            isEditorFocused = newValue
        }
        .sheet(item: $store.scope(state: \.entryDetail, action: \.entryDetail)) { store in
            EntryEditorSheet(store: store)
        }
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        if store.isEditing {
            // Inline editor mode
            inlineEditorContent
        } else if store.isLoading && store.entries.isEmpty {
            // Loading state
            LoadingView()
        } else if store.entries.isEmpty {
            // Empty state - tappable to start editing
            EmptyStateView {
                store.send(.startEditing)
            }
        } else {
            // Entry list
            EntryListView(store: store)
        }
    }
    
    // MARK: - Inline Editor Content
    
    private var inlineEditorContent: some View {
        VStack(spacing: 0) {
            // Text editor area
            ScrollView {
                InlineEditorView(
                    text: Binding(
                        get: { store.editorText },
                        set: { store.send(.editorTextChanged($0)) }
                    ),
                    placeholder: store.placeholderText,
                    isFocused: $isEditorFocused
                )
                .frame(minHeight: 200)
                .padding(.top, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                KeyboardAccessoryBar(
                    streak: store.streak,
                    isRecording: store.isRecording,
                    audioLevels: store.audioLevels,
                    onMicTap: { store.send(.micTapped) },
                    onCameraTap: { store.send(.cameraTapped) },
                    onAttachTap: { store.send(.attachTapped) },
                    onDismissTap: { store.send(.dismissKeyboard) },
                    onConfirmRecording: { store.send(.confirmRecording) },
                    onCancelRecording: { store.send(.cancelRecording) }
                )
            }
        }
    }
}

// MARK: - Entry List View

private struct EntryListView: View {
    
    @Bindable var store: StoreOf<JournalFeature>
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Invisible anchor for scroll-to-top
                    Color.clear
                        .frame(height: 1)
                        .id("top")
                    
                    ForEach(store.entries) { entryState in
                        EntryRowView(entry: entryState.entry)
                            .onTapGesture {
                                store.send(.entryTapped(entryState.id))
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    store.send(.deleteEntry(entryState.id))
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    
                    // Bottom padding for floating bar
                    Color.clear
                        .frame(height: 80)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .onChange(of: store.scrollToTopTrigger) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("top", anchor: .top)
                }
            }
        }
    }
}

// MARK: - Loading View

private struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .tint(.minaSecondary)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    JournalTabView(
        store: Store(
            initialState: JournalFeature.State(
                entries: IdentifiedArrayOf(
                    uniqueElements: JournalEntry.samples.map { JournalEntryState(entry: $0) }
                ),
                streak: 7
            )
        ) {
            JournalFeature()
        }
    )
}

#Preview("Empty State") {
    JournalTabView(
        store: Store(
            initialState: JournalFeature.State()
        ) {
            JournalFeature()
        }
    )
}

#Preview("Editing Mode") {
    JournalTabView(
        store: Store(
            initialState: JournalFeature.State(
                streak: 5,
                isEditing: true,
                editorFocused: true
            )
        ) {
            JournalFeature()
        }
    )
}

#Preview("Recording Mode") {
    JournalTabView(
        store: Store(
            initialState: JournalFeature.State(
                streak: 5,
                isEditing: true,
                editorFocused: true,
                isRecording: true,
                audioLevels: (0..<30).map { _ in CGFloat.random(in: 0.2...1.0) }
            )
        ) {
            JournalFeature()
        }
    )
}
