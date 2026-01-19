import SwiftUI
import ComposableArchitecture

// MARK: - Preferred Time View
// Screen 5: Ask when user prefers to journal

struct PreferredTimeView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .sleeping, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("When do you prefer to journal?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("We'll send reminders at the right time")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Time preset options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(TimePreset.allCases) { preset in
                        OnboardingOptionCard(
                            title: preset.title,
                            subtitle: preset.subtitle,
                            systemImage: preset.icon,
                            isSelected: store.data.preferredTimePreset == preset.rawValue
                        ) {
                            store.send(.timePresetSelected(preset))
                        }
                    }
                    
                    // Custom time picker
                    if store.showingTimePicker {
                        VStack(spacing: 12) {
                            Text("Select your preferred time")
                                .font(.minaSubheadline)
                                .foregroundStyle(Color.minaSecondary)
                            
                            DatePicker(
                                "Time",
                                selection: Binding(
                                    get: { store.data.preferredTime ?? Date() },
                                    set: { store.send(.customTimeChanged($0)) }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.minaCardSolid)
                        )
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
    PreferredTimeView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
