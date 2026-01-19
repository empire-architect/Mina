import Foundation
import SwiftUI

// MARK: - Onboarding Step Enum

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome = 0
    case whyJournal = 1
    case experienceLevel = 2
    case journalingGoal = 3
    case preferredTime = 4
    case topics = 5
    case aiAssistance = 6
    case privacySecurity = 7
    case healthSync = 8
    case notifications = 9
    case setupSummary = 10
    case createAccount = 11
    
    var id: Int { rawValue }
    
    /// Total number of steps (for progress indicator)
    static var totalSteps: Int { allCases.count }
    
    /// Whether this step can be skipped
    var isOptional: Bool {
        switch self {
        case .preferredTime, .topics, .healthSync:
            return true
        default:
            return false
        }
    }
    
    /// Whether the Next button requires a selection
    var requiresSelection: Bool {
        switch self {
        case .welcome, .preferredTime, .topics, .privacySecurity, 
             .healthSync, .notifications, .setupSummary:
            return false
        case .whyJournal, .experienceLevel, .journalingGoal, 
             .aiAssistance, .createAccount:
            return true
        }
    }
    
    /// Title shown in navigation (if any)
    var navigationTitle: String? {
        switch self {
        case .welcome, .createAccount:
            return nil
        default:
            return nil // We use inline titles instead
        }
    }
}

// MARK: - Journaling Motivation

enum JournalingMotivation: String, CaseIterable, Identifiable, Codable {
    case mentalClarity = "mental_clarity"
    case reduceStress = "reduce_stress"
    case personalGrowth = "personal_growth"
    case trackLife = "track_life"
    case creativeExpression = "creative_expression"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .mentalClarity: return "Mental clarity"
        case .reduceStress: return "Reduce stress & anxiety"
        case .personalGrowth: return "Personal growth"
        case .trackLife: return "Track life events"
        case .creativeExpression: return "Creative expression"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .mentalClarity: return "Organize thoughts and gain focus"
        case .reduceStress: return "Process emotions and find calm"
        case .personalGrowth: return "Reflect, learn, and evolve"
        case .trackLife: return "Document memories and milestones"
        case .creativeExpression: return "Explore ideas and imagination"
        }
    }
    
    var icon: String {
        switch self {
        case .mentalClarity: return "brain.head.profile"
        case .reduceStress: return "heart.circle"
        case .personalGrowth: return "arrow.up.forward.circle"
        case .trackLife: return "calendar.circle"
        case .creativeExpression: return "paintbrush"
        }
    }
    
    var emoji: String {
        switch self {
        case .mentalClarity: return "🧠"
        case .reduceStress: return "😌"
        case .personalGrowth: return "🌱"
        case .trackLife: return "📝"
        case .creativeExpression: return "✨"
        }
    }
}

// MARK: - Experience Level

enum ExperienceLevel: String, CaseIterable, Identifiable, Codable {
    case newToJournaling = "new"
    case journaledBefore = "some_experience"
    case regularJournaler = "experienced"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .newToJournaling: return "New to journaling"
        case .journaledBefore: return "I've journaled before"
        case .regularJournaler: return "I journal regularly"
        }
    }
    
    var subtitle: String {
        switch self {
        case .newToJournaling: return "I'll guide you every step of the way"
        case .journaledBefore: return "Great! We'll build on your experience"
        case .regularJournaler: return "Welcome back! Let's enhance your practice"
        }
    }
    
    var icon: String {
        switch self {
        case .newToJournaling: return "sparkles"
        case .journaledBefore: return "book"
        case .regularJournaler: return "star.fill"
        }
    }
}

// MARK: - Journaling Frequency

enum JournalingFrequency: String, CaseIterable, Identifiable, Codable {
    case daily = "daily"
    case weekdays = "weekdays"
    case fewTimesWeek = "few_times_week"
    case weekly = "weekly"
    case noGoal = "no_goal"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .daily: return "Every day"
        case .weekdays: return "Weekdays"
        case .fewTimesWeek: return "A few times a week"
        case .weekly: return "Once a week"
        case .noGoal: return "No specific goal"
        }
    }
    
    var subtitle: String {
        switch self {
        case .daily: return "Build a daily reflection habit"
        case .weekdays: return "5 days a week, weekends off"
        case .fewTimesWeek: return "2-3 times per week"
        case .weekly: return "A weekly check-in"
        case .noGoal: return "Write whenever inspiration strikes"
        }
    }
    
    var icon: String {
        switch self {
        case .daily: return "flame.fill"
        case .weekdays: return "calendar"
        case .fewTimesWeek: return "calendar.badge.clock"
        case .weekly: return "calendar.circle"
        case .noGoal: return "wind"
        }
    }
}

// MARK: - Journal Topics

enum JournalTopic: String, CaseIterable, Identifiable, Codable {
    case gratitude = "gratitude"
    case mindfulness = "mindfulness"
    case dreams = "dreams"
    case goals = "goals"
    case relationships = "relationships"
    case career = "career"
    case health = "health"
    case creativity = "creativity"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .gratitude: return "Gratitude"
        case .mindfulness: return "Mindfulness"
        case .dreams: return "Dreams"
        case .goals: return "Goals"
        case .relationships: return "Relationships"
        case .career: return "Career"
        case .health: return "Health & Wellness"
        case .creativity: return "Creativity"
        }
    }
    
    var emoji: String {
        switch self {
        case .gratitude: return "🙏"
        case .mindfulness: return "🧘"
        case .dreams: return "💭"
        case .goals: return "🎯"
        case .relationships: return "❤️"
        case .career: return "💼"
        case .health: return "🌿"
        case .creativity: return "🎨"
        }
    }
    
    var icon: String {
        switch self {
        case .gratitude: return "heart.text.square"
        case .mindfulness: return "brain"
        case .dreams: return "moon.stars"
        case .goals: return "target"
        case .relationships: return "person.2"
        case .career: return "briefcase"
        case .health: return "leaf"
        case .creativity: return "paintpalette"
        }
    }
}

// MARK: - AI Assistance Level

enum AIAssistanceLevel: Int, CaseIterable, Identifiable, Codable {
    case minimal = 0
    case gentle = 1
    case balanced = 2
    case active = 3
    case full = 4
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .minimal: return "Minimal"
        case .gentle: return "Gentle"
        case .balanced: return "Balanced"
        case .active: return "Active"
        case .full: return "Full Guidance"
        }
    }
    
    var description: String {
        switch self {
        case .minimal: 
            return "I'll stay quiet unless you ask for help"
        case .gentle: 
            return "Occasional prompts when you seem stuck"
        case .balanced: 
            return "Helpful suggestions without being intrusive"
        case .active: 
            return "Regular prompts and writing ideas"
        case .full: 
            return "Comprehensive guidance and daily prompts"
        }
    }
    
    var example: String {
        switch self {
        case .minimal:
            return "You write freely, AI helps on request"
        case .gentle:
            return "Subtle nudges after long pauses"
        case .balanced:
            return "Daily prompt + gentle suggestions"
        case .active:
            return "Multiple prompts + follow-up questions"
        case .full:
            return "Structured journaling with guided exercises"
        }
    }
    
    /// Slider position (0.0 - 1.0)
    var sliderValue: Double {
        Double(rawValue) / Double(AIAssistanceLevel.allCases.count - 1)
    }
    
    /// Create from slider value
    static func from(sliderValue: Double) -> AIAssistanceLevel {
        let index = Int(round(sliderValue * Double(allCases.count - 1)))
        let clampedIndex = max(0, min(allCases.count - 1, index))
        return allCases[clampedIndex]
    }
}

// MARK: - Preferred Time Presets

enum TimePreset: String, CaseIterable, Identifiable {
    case morning = "morning"
    case afternoon = "afternoon"
    case evening = "evening"
    case night = "night"
    case custom = "custom"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .morning: return "Morning"
        case .afternoon: return "Afternoon"
        case .evening: return "Evening"
        case .night: return "Night"
        case .custom: return "Custom"
        }
    }
    
    var subtitle: String {
        switch self {
        case .morning: return "6:00 - 9:00 AM"
        case .afternoon: return "12:00 - 2:00 PM"
        case .evening: return "6:00 - 8:00 PM"
        case .night: return "9:00 - 11:00 PM"
        case .custom: return "Set your own time"
        }
    }
    
    var icon: String {
        switch self {
        case .morning: return "sunrise"
        case .afternoon: return "sun.max"
        case .evening: return "sunset"
        case .night: return "moon.stars"
        case .custom: return "clock"
        }
    }
    
    var defaultTime: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        
        switch self {
        case .morning: 
            components.hour = 7
            components.minute = 0
        case .afternoon: 
            components.hour = 13
            components.minute = 0
        case .evening: 
            components.hour = 19
            components.minute = 0
        case .night: 
            components.hour = 21
            components.minute = 0
        case .custom: 
            components.hour = 20
            components.minute = 0
        }
        
        return calendar.date(from: components) ?? Date()
    }
}

// MARK: - Capybara Pose

enum CapybaraPose: String, CaseIterable {
    case relaxing = "relaxing"
    case thinking = "thinking"
    case reading = "reading"
    case planning = "planning"
    case sleeping = "sleeping"
    case meditating = "meditating"
    case balanced = "balanced"
    case secure = "secure"
    case healthy = "healthy"
    case alert = "alert"
    case celebrating = "celebrating"
    case waving = "waving"
    
    /// SF Symbol to use as placeholder until real illustrations
    var placeholderSymbol: String {
        switch self {
        case .relaxing: return "figure.pool.swim"
        case .thinking: return "bubble.left.and.bubble.right"
        case .reading: return "book.fill"
        case .planning: return "checklist"
        case .sleeping: return "moon.zzz.fill"
        case .meditating: return "figure.mind.and.body"
        case .balanced: return "scale.3d"
        case .secure: return "lock.shield.fill"
        case .healthy: return "heart.fill"
        case .alert: return "bell.fill"
        case .celebrating: return "hands.clap.fill"
        case .waving: return "hand.wave.fill"
        }
    }
    
    /// Pose for each onboarding step
    static func forStep(_ step: OnboardingStep) -> CapybaraPose {
        switch step {
        case .welcome: return .relaxing
        case .whyJournal: return .thinking
        case .experienceLevel: return .reading
        case .journalingGoal: return .planning
        case .preferredTime: return .sleeping
        case .topics: return .meditating
        case .aiAssistance: return .balanced
        case .privacySecurity: return .secure
        case .healthSync: return .healthy
        case .notifications: return .alert
        case .setupSummary: return .celebrating
        case .createAccount: return .waving
        }
    }
}

// MARK: - Onboarding Data (Collected User Preferences)

struct OnboardingData: Equatable, Codable {
    var motivation: JournalingMotivation?
    var experienceLevel: ExperienceLevel?
    var frequency: JournalingFrequency?
    var preferredTimePreset: String? // TimePreset rawValue
    var preferredTime: Date?
    var topics: Set<JournalTopic> = []
    var customTopic: String = ""
    var aiLevel: AIAssistanceLevel = .balanced
    var enablePasscode: Bool = false
    var syncHealth: Bool = false
    var enableNotifications: Bool = true
    var reminderTime: Date?
    
    /// Check if minimum required data is collected
    var isComplete: Bool {
        motivation != nil &&
        experienceLevel != nil &&
        frequency != nil
    }
    
    /// Generate AI personality summary based on choices
    var aiPersonalitySummary: String {
        var parts: [String] = []
        
        if let motivation = motivation {
            switch motivation {
            case .mentalClarity:
                parts.append("help you organize your thoughts")
            case .reduceStress:
                parts.append("support your emotional wellbeing")
            case .personalGrowth:
                parts.append("encourage your personal development")
            case .trackLife:
                parts.append("help you document your journey")
            case .creativeExpression:
                parts.append("spark your creativity")
            }
        }
        
        if let frequency = frequency {
            switch frequency {
            case .daily:
                parts.append("with daily reflection prompts")
            case .weekdays:
                parts.append("on weekdays")
            case .fewTimesWeek:
                parts.append("a few times each week")
            case .weekly:
                parts.append("with weekly check-ins")
            case .noGoal:
                parts.append("whenever you're ready")
            }
        }
        
        let topicList = topics.prefix(3).map { $0.title.lowercased() }
        if !topicList.isEmpty {
            parts.append("focusing on \(topicList.joined(separator: ", "))")
        }
        
        return "I'll \(parts.joined(separator: " "))."
    }
}

// MARK: - Persistence

extension OnboardingData {
    private static let userDefaultsKey = "mina_onboarding_data"
    
    /// Save to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
    
    /// Load from UserDefaults
    static func load() -> OnboardingData? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode(OnboardingData.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    /// Clear saved data
    static func clear() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
