import SwiftUI
import ComposableArchitecture

// MARK: - Why Journal View
// Screen 2: Ask user's primary motivation for journaling

struct WhyJournalView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .thinking, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Why do you want to journal?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("This helps us personalize your experience")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(JournalingMotivation.allCases) { motivation in
                        OnboardingOptionCard(
                            title: motivation.title,
                            subtitle: motivation.subtitle,
                            emoji: motivation.emoji,
                            isSelected: store.data.motivation == motivation
                        ) {
                            store.send(.motivationSelected(motivation))
                        }
                    }
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
    WhyJournalView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}

#Preview("With Selection") {
    WhyJournalView(
        store: Store(
            initialState: OnboardingFeature.State(
                data: OnboardingData(motivation: .mentalClarity)
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
