import SwiftUI
import ComposableArchitecture

// MARK: - AI Assistance View
// Screen 7: Configure AI assistance level

struct AIAssistanceView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .balanced, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("How should Mina help you write?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Adjust how much AI guidance you receive")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            // Slider
            OnboardingSlider(value: $store.aiSliderValue)
                .padding(.horizontal, 24)
            
            Spacer()
            
            // Example text
            VStack(spacing: 8) {
                Text("Example")
                    .font(.minaCaption1)
                    .foregroundStyle(Color.minaSecondary)
                
                Text(store.data.aiLevel.example)
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

// MARK: - Preview

#Preview {
    AIAssistanceView(
        store: Store(
            initialState: OnboardingFeature.State(
                aiSliderValue: 0.5
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
