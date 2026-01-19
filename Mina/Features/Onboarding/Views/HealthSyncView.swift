import SwiftUI
import ComposableArchitecture

// MARK: - Health Sync View
// Screen 9: Apple Health integration

struct HealthSyncView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .healthy, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Connect with Apple Health")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Correlate your mood with health metrics")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Toggle
            OnboardingToggleRow(
                title: "Sync with Apple Health",
                subtitle: "Track mood alongside sleep, exercise, and more",
                systemImage: "heart.fill",
                iconColor: .red,
                isOn: Binding(
                    get: { store.data.syncHealth },
                    set: { store.send(.healthSyncToggled($0)) }
                )
            )
            .padding(.horizontal, 24)
            
            // Benefits section
            if store.data.syncHealth {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What you'll get")
                        .font(.minaHeadline)
                        .foregroundStyle(Color.minaPrimary)
                    
                    BenefitRow(
                        icon: "chart.line.uptrend.xyaxis",
                        text: "See how sleep affects your mood"
                    )
                    
                    BenefitRow(
                        icon: "figure.walk",
                        text: "Track exercise impact on wellbeing"
                    )
                    
                    BenefitRow(
                        icon: "brain.head.profile",
                        text: "Discover patterns in your mental health"
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.minaCardSolid)
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            
            Spacer()
            
            // Skip hint
            Text("You can enable this later in settings")
                .font(.minaCaption1)
                .foregroundStyle(Color.minaSecondary)
                .padding(.bottom, 24)
        }
    }
}

// MARK: - Benefit Row

private struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.minaAccent)
                .frame(width: 24)
            
            Text(text)
                .font(.minaSubheadline)
                .foregroundStyle(Color.minaSecondary)
        }
    }
}

// MARK: - Preview

#Preview {
    HealthSyncView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}

#Preview("Enabled") {
    HealthSyncView(
        store: Store(
            initialState: OnboardingFeature.State(
                data: OnboardingData(syncHealth: true)
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
