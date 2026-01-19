import SwiftUI
import ComposableArchitecture

// MARK: - Experience Level View
// Screen 3: Ask user's journaling experience

struct ExperienceLevelView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .reading, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("What's your experience with journaling?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("We'll tailor the guidance to your level")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Options
            VStack(spacing: 12) {
                ForEach(ExperienceLevel.allCases) { level in
                    OnboardingOptionCard(
                        title: level.title,
                        subtitle: level.subtitle,
                        systemImage: level.icon,
                        isSelected: store.data.experienceLevel == level
                    ) {
                        store.send(.experienceLevelSelected(level))
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ExperienceLevelView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
