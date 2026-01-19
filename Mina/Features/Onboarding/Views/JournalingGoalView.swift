import SwiftUI
import ComposableArchitecture

// MARK: - Journaling Goal View
// Screen 4: Ask how often user wants to journal

struct JournalingGoalView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .planning, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("How often do you want to journal?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Set a goal that feels achievable")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(JournalingFrequency.allCases) { frequency in
                        OnboardingOptionCard(
                            title: frequency.title,
                            subtitle: frequency.subtitle,
                            systemImage: frequency.icon,
                            isSelected: store.data.frequency == frequency
                        ) {
                            store.send(.frequencySelected(frequency))
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
    JournalingGoalView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
