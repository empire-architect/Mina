import SwiftUI

// MARK: - Onboarding Option Card
// Selectable row for single-choice options (matches Amy reference style)

struct OnboardingOptionCard<Icon: View>: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let icon: () -> Icon
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        isSelected: Bool,
        @ViewBuilder icon: @escaping () -> Icon,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                icon()
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? Color.minaAccent : Color.minaSecondary)
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
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.minaAccent)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.minaCardSolid)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.minaAccent : Color.clear, lineWidth: 2)
                    )
            )
            .shadow(color: .minaShadow, radius: isSelected ? 8 : 4, y: isSelected ? 4 : 2)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Convenience initializers

extension OnboardingOptionCard where Icon == Image {
    /// Create with SF Symbol
    init(
        title: String,
        subtitle: String? = nil,
        systemImage: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            isSelected: isSelected,
            icon: { Image(systemName: systemImage) },
            action: action
        )
    }
}

extension OnboardingOptionCard where Icon == Text {
    /// Create with emoji
    init(
        title: String,
        subtitle: String? = nil,
        emoji: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            isSelected: isSelected,
            icon: { Text(emoji).font(.title2) },
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        OnboardingOptionCard(
            title: "Mental clarity",
            subtitle: "Organize thoughts and gain focus",
            systemImage: "brain.head.profile",
            isSelected: true,
            action: {}
        )
        
        OnboardingOptionCard(
            title: "Reduce stress & anxiety",
            subtitle: "Process emotions and find calm",
            systemImage: "heart.circle",
            isSelected: false,
            action: {}
        )
        
        OnboardingOptionCard(
            title: "Personal growth",
            subtitle: "Reflect, learn, and evolve",
            emoji: "🌱",
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(Color.minaBackground)
}
