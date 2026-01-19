import SwiftUI

// MARK: - Capybara Illustration
// Placeholder component for the Capybara mascot
// Uses SF Symbols until real illustrations are provided

struct CapybaraIllustration: View {
    let pose: CapybaraPose
    var size: CGFloat = 200
    
    var body: some View {
        ZStack {
            // Background circle with gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.minaAccent.opacity(0.15),
                            Color.minaAccent.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
            
            // Decorative elements
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(Color.minaAccent.opacity(0.2))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: cos(Double(index) * .pi / 3) * (size / 2.5),
                        y: sin(Double(index) * .pi / 3) * (size / 2.5)
                    )
            }
            
            // Main icon (placeholder for capybara illustration)
            VStack(spacing: 8) {
                Image(systemName: pose.placeholderSymbol)
                    .font(.system(size: size * 0.35))
                    .foregroundStyle(Color.minaAccent)
                
                // Small "MINA" text for welcome screen
                if pose == .relaxing {
                    Text("MINA")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.minaAccent)
                        .tracking(4)
                }
            }
            
            // Sparkle decorations
            Image(systemName: "sparkle")
                .font(.system(size: 12))
                .foregroundStyle(Color.minaAccent.opacity(0.6))
                .offset(x: size * 0.3, y: -size * 0.25)
            
            Image(systemName: "sparkle")
                .font(.system(size: 8))
                .foregroundStyle(Color.minaAccent.opacity(0.4))
                .offset(x: -size * 0.35, y: size * 0.2)
            
            Image(systemName: "sparkle")
                .font(.system(size: 10))
                .foregroundStyle(Color.minaAccent.opacity(0.5))
                .offset(x: size * 0.25, y: size * 0.3)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Animated Capybara

struct AnimatedCapybaraIllustration: View {
    let pose: CapybaraPose
    var size: CGFloat = 200
    
    @State private var isAnimating = false
    
    var body: some View {
        CapybaraIllustration(pose: pose, size: size)
            .scaleEffect(isAnimating ? 1.02 : 1.0)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Preview

#Preview("All Poses") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(CapybaraPose.allCases, id: \.self) { pose in
                VStack {
                    CapybaraIllustration(pose: pose, size: 120)
                    Text(pose.rawValue)
                        .font(.minaCaption1)
                        .foregroundStyle(Color.minaSecondary)
                }
            }
        }
        .padding()
    }
    .background(Color.minaBackground)
}

#Preview("Animated") {
    AnimatedCapybaraIllustration(pose: .relaxing, size: 250)
        .background(Color.minaBackground)
}
