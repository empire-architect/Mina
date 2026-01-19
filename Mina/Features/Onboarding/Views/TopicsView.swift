import SwiftUI
import ComposableArchitecture

// MARK: - Topics View
// Screen 6: Select journaling topics of interest

struct TopicsView: View {
    let store: StoreOf<OnboardingFeature>
    @State private var customTopic: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .meditating, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("What do you want to explore?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Select all that interest you (optional)")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Topics grid
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Topic chips
                    FlowLayout(spacing: 10) {
                        ForEach(JournalTopic.allCases) { topic in
                            OnboardingChip(
                                title: topic.title,
                                emoji: topic.emoji,
                                isSelected: store.data.topics.contains(topic)
                            ) {
                                store.send(.topicToggled(topic))
                            }
                        }
                    }
                    
                    // Custom topic input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Anything else? (optional)")
                            .font(.minaSubheadline)
                            .foregroundStyle(Color.minaSecondary)
                        
                        TextField(
                            "e.g. 'Starting a business', 'Learning a language'",
                            text: Binding(
                                get: { store.data.customTopic },
                                set: { store.send(.customTopicChanged($0)) }
                            )
                        )
                        .font(.minaBody)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.minaCardSolid)
                        )
                    }
                    
                    // Info text
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                        Text("These help personalize your prompts. You can change them anytime in settings.")
                            .font(.minaCaption1)
                    }
                    .foregroundStyle(Color.minaSecondary)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Preview

#Preview {
    TopicsView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}

#Preview("With Selections") {
    TopicsView(
        store: Store(
            initialState: OnboardingFeature.State(
                data: OnboardingData(
                    topics: [.gratitude, .mindfulness, .goals]
                )
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
