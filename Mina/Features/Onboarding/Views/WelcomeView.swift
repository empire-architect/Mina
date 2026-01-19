import SwiftUI
import ComposableArchitecture

// MARK: - Welcome View
// Screen 1: Welcome to Mina

struct WelcomeView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Capybara illustration
            AnimatedCapybaraIllustration(pose: .relaxing, size: 220)
                .padding(.bottom, 40)
            
            // Welcome text
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome to Mina")
                    .font(.minaLargeTitle)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Your private space for thoughts, reflections, and self-discovery.")
                    .font(.minaBody)
                    .foregroundStyle(Color.minaSecondary)
                
                Text("Built so you stick with it.")
                    .font(.minaBody)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            Spacer()
            Spacer()
            
            // Get Started button
            VStack(spacing: 16) {
                Button {
                    store.send(.getStartedTapped)
                } label: {
                    Text("Get Started")
                        .font(.minaHeadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(Color.minaAccent)
                        )
                        .shadow(color: Color.minaAccent.opacity(0.3), radius: 8, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                
                // Sign in link
                Button {
                    store.send(.signInTapped)
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(Color.minaSecondary)
                        Text("Sign in")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.minaPrimary)
                    }
                    .font(.minaSubheadline)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
