import SwiftUI
import ComposableArchitecture

// MARK: - Notifications View
// Screen 10: Notification preferences

struct NotificationsView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration
            CapybaraIllustration(pose: .alert, size: 180)
                .padding(.top, 20)
                .padding(.bottom, 32)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Enable Notifications?")
                    .font(.minaTitle2)
                    .foregroundStyle(Color.minaPrimary)
                
                Text("Mina can send gentle reminders to help you build a journaling habit")
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Toggle
            OnboardingToggleRow(
                title: "Enable Notifications",
                subtitle: "Get daily reminders to journal",
                systemImage: "bell.fill",
                iconColor: .blue,
                isOn: Binding(
                    get: { store.data.enableNotifications },
                    set: { store.send(.notificationsToggled($0)) }
                )
            )
            .padding(.horizontal, 24)
            
            // Time picker when enabled
            if store.data.enableNotifications {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reminder time")
                        .font(.minaHeadline)
                        .foregroundStyle(Color.minaPrimary)
                    
                    DatePicker(
                        "Time",
                        selection: Binding(
                            get: { store.data.reminderTime ?? store.data.preferredTime ?? defaultReminderTime },
                            set: { store.send(.reminderTimeChanged($0)) }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 150)
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
            
            // Info text
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                Text("You can customize notification settings anytime")
                    .font(.minaCaption1)
            }
            .foregroundStyle(Color.minaSecondary)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    private var defaultReminderTime: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 20
        components.minute = 0
        return calendar.date(from: components) ?? Date()
    }
}

// MARK: - Preview

#Preview {
    NotificationsView(
        store: Store(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}

#Preview("Disabled") {
    NotificationsView(
        store: Store(
            initialState: OnboardingFeature.State(
                data: OnboardingData(enableNotifications: false)
            )
        ) {
            OnboardingFeature()
        }
    )
    .background(Color.minaBackground)
}
