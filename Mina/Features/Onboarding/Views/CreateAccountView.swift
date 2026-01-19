import SwiftUI
import ComposableArchitecture

// MARK: - Create Account View
// Screen 12: Account creation / sign up

struct CreateAccountView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .waving, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Save Your Progress")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Create an account to sync your data across devices and never lose your progress.")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            // Auth buttons
            VStack(spacing: 12) {
                // Continue with Apple
                Button {
                    store.send(.continueWithAppleTapped)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                        Text("Continue with Apple")
                            .font(.minaHeadline)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )
                }
                .buttonStyle(.plain)
                
                // Continue with Google
                Button {
                    store.send(.continueWithGoogleTapped)
                } label: {
                    HStack(spacing: 10) {
                        // Google "G" placeholder
                        Text("G")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .yellow, .green, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Continue with Google")
                            .font(.minaHeadline)
                            .foregroundStyle(Color.minaPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.minaCardSolid)
                            .overlay(
                                Capsule()
                                    .stroke(Color.minaDivider, lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(Color.minaDivider)
                        .frame(height: 1)
                    Text("or")
                        .font(.minaCaption1)
                        .foregroundStyle(Color.minaSecondary)
                        .padding(.horizontal, 16)
                    Rectangle()
                        .fill(Color.minaDivider)
                        .frame(height: 1)
                }
                .padding(.vertical, 8)
                
                // Use email
                Button {
                    store.send(.continueWithEmailTapped)
                } label: {
                    Text("Use email instead")
                        .font(.minaHeadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.minaAccent.opacity(0.8))
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Skip for now
            Button {
                store.send(.skipAccountTapped)
            } label: {
                Text("Skip for now")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
                    .underline()
            }
            .buttonStyle(.plain)
            .padding(.bottom, 8)
            
            // Privacy note
            Text("Your data stays on this device until you create an account")
                .font(.minaCaption1)
                .foregroundStyle(Color.minaSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .overlay {
            if store.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CreateAccountView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}

#Preview("Loading") {
    CreateAccountView(
        store: Store(
            initialState: OnboardingFeature.State(isLoading: true)
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
