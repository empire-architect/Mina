import SwiftUI

// MARK: - Onboarding Navigation View
// Back and Next buttons for onboarding flow

struct OnboardingNavigationView: View {
    let showBack: Bool
    let nextText: String
    let canProceed: Bool
    let isLoading: Bool
    let onBack: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Back button
            if showBack {
                Button(action: onBack) {
                    ZStack {
                        Circle()
                            .fill(Color.minaCardSolid)
                            .frame(width: 56, height: 56)
                            .shadow(color: .minaShadow, radius: 4, y: 2)
                        
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.minaSecondary)
                    }
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            // Next button
            if !nextText.isEmpty {
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text(nextText)
                                .font(.minaHeadline)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(canProceed ? Color.minaAccent : Color.minaSecondary.opacity(0.5))
                    )
                    .shadow(color: canProceed ? Color.minaAccent.opacity(0.3) : .clear, radius: 8, y: 4)
                }
                .buttonStyle(.plain)
                .disabled(!canProceed || isLoading)
                .animation(.easeInOut(duration: 0.2), value: canProceed)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

// MARK: - Simple Back Button

struct OnboardingBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                Text("Back")
                    .font(.minaSubheadline)
            }
            .foregroundStyle(Color.minaSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.minaCardSolid)
                    .shadow(color: .minaShadow, radius: 2, y: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Navigation") {
    VStack(spacing: 40) {
        OnboardingNavigationView(
            showBack: false,
            nextText: "Get Started",
            canProceed: true,
            isLoading: false,
            onBack: {},
            onNext: {}
        )
        
        OnboardingNavigationView(
            showBack: true,
            nextText: "Next",
            canProceed: true,
            isLoading: false,
            onBack: {},
            onNext: {}
        )
        
        OnboardingNavigationView(
            showBack: true,
            nextText: "Next",
            canProceed: false,
            isLoading: false,
            onBack: {},
            onNext: {}
        )
        
        OnboardingNavigationView(
            showBack: true,
            nextText: "Continue",
            canProceed: true,
            isLoading: true,
            onBack: {},
            onNext: {}
        )
    }
    .background(Color.minaBackground)
}
