import SwiftUI

// MARK: - Onboarding Toggle Row
// Toggle component with icon, title, and subtitle

struct OnboardingToggleRow: View {
    let title: String
    let subtitle: String?
    let systemImage: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        systemImage: String,
        iconColor: Color = .minaAccent,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.iconColor = iconColor
        self._isOn = isOn
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: systemImage)
                .font(.system(size: 22))
                .foregroundStyle(iconColor)
                .frame(width: 32)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.minaHeadline)
                    .foregroundStyle(Color.minaPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.minaCaption1)
                        .foregroundStyle(Color.minaSecondary)
                }
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.minaAccent))
                .labelsHidden()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.minaCardSolid)
        )
        .shadow(color: .minaShadow, radius: 4, y: 2)
    }
}

// MARK: - Simple Toggle Row (without card background)

struct SimpleToggleRow: View {
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.minaBody)
                    .foregroundStyle(Color.minaPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.minaCaption1)
                        .foregroundStyle(Color.minaSecondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.minaAccent))
                .labelsHidden()
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        OnboardingToggleRow(
            title: "Enable Notifications",
            subtitle: "Get gentle reminders to journal",
            systemImage: "bell.fill",
            iconColor: .blue,
            isOn: .constant(true)
        )
        
        OnboardingToggleRow(
            title: "Sync with Apple Health",
            subtitle: "Track mood alongside health data",
            systemImage: "heart.fill",
            iconColor: .red,
            isOn: .constant(false)
        )
        
        OnboardingToggleRow(
            title: "Enable Location Services",
            subtitle: "Add location context to entries",
            systemImage: "location.fill",
            iconColor: .green,
            isOn: .constant(false)
        )
    }
    .padding()
    .background(Color.minaBackground)
}
