import SwiftUI
import ComposableArchitecture

// MARK: - Onboarding Container View
// Main wrapper that manages navigation between onboarding steps

struct OnboardingContainerView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        ZStack {
            // Background
            Color.minaBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator (hidden on welcome screen)
                if store.currentStep != .welcome {
                    OnboardingProgressView(
                        currentStep: store.currentStep.rawValue,
                        totalSteps: OnboardingStep.totalSteps
                    )
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                
                // Content area
                TabView(selection: Binding(
                    get: { store.currentStep },
                    set: { store.send(.goToStep($0)) }
                )) {
                    ForEach(OnboardingStep.allCases) { step in
                        stepView(for: step)
                            .tag(step)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: store.currentStep)
                
                // Navigation (hidden on welcome and create account screens)
                if store.currentStep != .welcome && store.currentStep != .createAccount {
                    OnboardingNavigationView(
                        showBack: store.showBackButton,
                        nextText: store.nextButtonText,
                        canProceed: store.canProceed,
                        isLoading: store.isLoading,
                        onBack: { store.send(.backTapped) },
                        onNext: { store.send(.nextTapped) }
                    )
                }
            }
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { store.errorMessage != nil },
                set: { if !$0 { store.send(.clearError) } }
            ),
            actions: {
                Button("OK") { store.send(.clearError) }
            },
            message: {
                Text(store.errorMessage ?? "An error occurred")
            }
        )
    }
    
    // MARK: - Step Views
    
    @ViewBuilder
    private func stepView(for step: OnboardingStep) -> some View {
        switch step {
        case .welcome:
            WelcomeView(store: store)
            
        case .whyJournal:
            WhyJournalView(store: store)
            
        case .experienceLevel:
            ExperienceLevelView(store: store)
            
        case .journalingGoal:
            JournalingGoalView(store: store)
            
        case .preferredTime:
            PreferredTimeView(store: store)
            
        case .topics:
            TopicsView(store: store)
            
        case .aiAssistance:
            AIAssistanceView(store: store)
            
        case .privacySecurity:
            PrivacySecurityView(store: store)
            
        case .healthSync:
            HealthSyncView(store: store)
            
        case .notifications:
            NotificationsView(store: store)
            
        case .setupSummary:
            SetupSummaryView(store: store)
            
        case .createAccount:
            CreateAccountView(store: store)
        }
    }
}

// MARK: - Preview

#Preview("Welcome") {
    OnboardingContainerView(
        store: Store(
            initialState: OnboardingFeature.State(currentStep: .welcome)
        ) {
            OnboardingFeature()
        }
    )
}

#Preview("Why Journal") {
    OnboardingContainerView(
        store: Store(
            initialState: OnboardingFeature.State(currentStep: .whyJournal)
        ) {
            OnboardingFeature()
        }
    )
}

#Preview("Topics") {
    OnboardingContainerView(
        store: Store(
            initialState: OnboardingFeature.State(currentStep: .topics)
        ) {
            OnboardingFeature()
        }
    )
}

#Preview("Summary") {
    OnboardingContainerView(
        store: Store(
            initialState: OnboardingFeature.State(
                currentStep: .setupSummary,
                data: OnboardingData(
                    motivation: .mentalClarity,
                    experienceLevel: .newToJournaling,
                    frequency: .daily,
                    topics: [.gratitude, .mindfulness],
                    aiLevel: .balanced,
                    enableNotifications: true
                )
            )
        ) {
            OnboardingFeature()
        }
    )
}
