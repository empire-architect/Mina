import SwiftUI

// MARK: - Onboarding Progress View
// Dot indicator showing current step in onboarding flow

struct OnboardingProgressView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { index in
                if index == currentStep {
                    // Active step - elongated pill
                    Capsule()
                        .fill(Color.minaAccent)
                        .frame(width: 24, height: 8)
                } else if index < currentStep {
                    // Completed step - filled circle
                    Circle()
                        .fill(Color.minaAccent.opacity(0.6))
                        .frame(width: 8, height: 8)
                } else {
                    // Future step - empty circle
                    Circle()
                        .fill(Color.minaSecondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        OnboardingProgressView(currentStep: 0, totalSteps: 12)
        OnboardingProgressView(currentStep: 3, totalSteps: 12)
        OnboardingProgressView(currentStep: 7, totalSteps: 12)
        OnboardingProgressView(currentStep: 11, totalSteps: 12)
    }
    .padding()
    .background(Color.minaBackground)
}
