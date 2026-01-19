import SwiftUI

// MARK: - Onboarding Slider
// Custom slider for AI assistance level selection

struct OnboardingSlider: View {
    @Binding var value: Double
    let levels: [AIAssistanceLevel]
    
    init(value: Binding<Double>, levels: [AIAssistanceLevel] = AIAssistanceLevel.allCases) {
        self._value = value
        self.levels = levels
    }
    
    private var currentLevel: AIAssistanceLevel {
        AIAssistanceLevel.from(sliderValue: value)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Current level display card
            VStack(spacing: 8) {
                Text(currentLevel.title)
                    .font(.minaTitle3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.minaPrimary)
                
                Text(currentLevel.description)
                    .font(.minaSubheadline)
                    .foregroundStyle(Color.minaSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.minaCardSolid)
            )
            .shadow(color: .minaShadow, radius: 4, y: 2)
            
            // Slider
            VStack(spacing: 16) {
                // Custom slider track
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Track background
                        Capsule()
                            .fill(Color.minaSecondary.opacity(0.2))
                            .frame(height: 8)
                        
                        // Filled portion
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.minaAccent.opacity(0.5), Color.minaAccent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * value, height: 8)
                        
                        // Thumb
                        Circle()
                            .fill(Color.minaCardSolid)
                            .frame(width: 28, height: 28)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                            .overlay(
                                Circle()
                                    .fill(Color.minaAccent)
                                    .frame(width: 12, height: 12)
                            )
                            .offset(x: (geometry.size.width - 28) * value)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { gesture in
                                        let newValue = gesture.location.x / geometry.size.width
                                        value = max(0, min(1, newValue))
                                    }
                            )
                    }
                }
                .frame(height: 28)
                
                // Level labels
                HStack {
                    ForEach(levels) { level in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(currentLevel == level ? Color.minaAccent : Color.minaSecondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                            
                            Text(level.title)
                                .font(.minaCaption2)
                                .foregroundStyle(
                                    currentLevel == level ? Color.minaAccent : Color.minaSecondary
                                )
                        }
                        
                        if level != levels.last {
                            Spacer()
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: value)
    }
}

// MARK: - Simple Labeled Slider

struct LabeledSlider: View {
    let title: String
    let leftLabel: String
    let rightLabel: String
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.minaHeadline)
                .foregroundStyle(Color.minaPrimary)
            
            Slider(value: $value, in: 0...1)
                .tint(Color.minaAccent)
            
            HStack {
                Text(leftLabel)
                    .font(.minaCaption1)
                    .foregroundStyle(Color.minaSecondary)
                
                Spacer()
                
                Text(rightLabel)
                    .font(.minaCaption1)
                    .foregroundStyle(Color.minaSecondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        OnboardingSlider(value: .constant(0.5))
        
        OnboardingSlider(value: .constant(0.0))
        
        OnboardingSlider(value: .constant(1.0))
    }
    .padding()
    .background(Color.minaBackground)
}
