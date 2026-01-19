import SwiftUI
import ComposableArchitecture

// MARK: - Privacy Security View
// Screen 8: Privacy and security settings

struct PrivacySecurityView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .secure, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Your privacy matters")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Your journal entries are encrypted and private")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Privacy features
            VStack(spacing: 16) {
                // Encryption info card
                HStack(spacing: 16) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("End-to-End Encryption")
                            .font(.minaHeadline)
                            .foregroundStyle(Color.minaPrimary)
                        
                        Text("Only you can read your entries")
                            .font(.minaCaption1)
                            .foregroundStyle(Color.minaSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.green)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.minaCardSolid)
                )
                
                // Passcode toggle
                OnboardingToggleRow(
                    title: "Enable Passcode",
                    subtitle: "Add an extra layer of protection",
                    systemImage: "faceid",
                    iconColor: .minaAccent,
                    isOn: Binding(
                        get: { store.data.enablePasscode },
                        set: { store.send(.passcodeToggled($0)) }
                    )
                )
                
                // Privacy badge
                HStack(spacing: 8) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 14))
                    Text("We never sell your data")
                        .font(.minaCaption1)
                }
                .foregroundStyle(Color.minaSecondary)
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    PrivacySecurityView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
