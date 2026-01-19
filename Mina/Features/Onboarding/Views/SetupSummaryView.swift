import SwiftUI
import ComposableArchitecture

// MARK: - Setup Summary View
// Screen 11: Summary of user's onboarding choices

struct SetupSummaryView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .celebrating, size: 160)
                .padding(.top, 20)
                .padding(.bottom, 24)
            
            // Title
            Text("Your Personalized Setup")
                .font(.minaTitle2)
                .foregroundStyle(Color.minaPrimary)
                .padding(.bottom, 24)
            
            // Summary card
            ScrollView {
                VStack(spacing: 16) {
                    // Preferences summary
                    SummaryCard {
                        SummaryRow(
                            icon: "target",
                            label: "Goal",
                            value: store.data.frequency?.title ?? "Not set"
                        )
                        
                        Divider()
                        
                        SummaryRow(
                            icon: "clock",
                            label: "Reminder",
                            value: formattedReminderTime
                        )
                        
                        Divider()
                        
                        SummaryRow(
                            icon: "tag",
                            label: "Focus",
                            value: topicsString
                        )
                        
                        Divider()
                        
                        SummaryRow(
                            icon: "sparkles",
                            label: "AI Mode",
                            value: store.data.aiLevel.title
                        )
                    }
                    
                    // AI personality preview
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .foregroundStyle(Color.minaAccent)
                            Text("Mina's First Impression")
                                .font(.minaHeadline)
                                .foregroundStyle(Color.minaPrimary)
                        }
                        
                        Text(store.data.aiPersonalitySummary)
                            .font(.minaBody)
                            .foregroundStyle(Color.minaSecondary)
                            .lineSpacing(4)
                        
                        Text("Based on your choices, I'm excited to be your journaling companion!")
                            .font(.minaSubheadline)
                            .foregroundStyle(Color.minaSecondary)
                            .italic()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.minaAccent.opacity(0.08))
                    )
                    
                    // Edit button
                    Button {
                        store.send(.editPreferencesTapped)
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Preferences")
                        }
                        .font(.minaSubheadline)
                        .foregroundStyle(Color.minaAccent)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    // MARK: - Computed Properties
    
    private var formattedReminderTime: String {
        guard let time = store.data.reminderTime ?? store.data.preferredTime else {
            return store.data.enableNotifications ? "8:00 PM" : "Off"
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    private var topicsString: String {
        if store.data.topics.isEmpty {
            return "All topics"
        }
        let topicNames = store.data.topics.prefix(3).map { $0.title }
        if store.data.topics.count > 3 {
            return topicNames.joined(separator: ", ") + "..."
        }
        return topicNames.joined(separator: ", ")
    }
}

// MARK: - Summary Card

private struct SummaryCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 12) {
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.minaCardSolid)
        )
        .shadow(color: .minaShadow, radius: 4, y: 2)
    }
}

// MARK: - Summary Row

private struct SummaryRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.minaAccent)
                    .frame(width: 24)
                
                Text(label)
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.minaSubheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.minaPrimary)
        }
    }
}

// MARK: - Preview

#Preview {
    SetupSummaryView(
        store: Store(
            initialState: OnboardingFeature.State(
                data: OnboardingData(
                    motivation: .mentalClarity,
                    experienceLevel: .newToJournaling,
                    frequency: .daily,
                    topics: [.gratitude, .mindfulness],
                    aiLevel: .balanced,
                    enableNotifications: true
                )
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
