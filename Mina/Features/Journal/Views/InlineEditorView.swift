import SwiftUI

// MARK: - Inline Editor View
// Text editor that appears inline in the content area (not a sheet)

struct InlineEditorView: View {
    
    @Binding var text: String
    let placeholder: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder
            if text.isEmpty {
                Text(placeholder)
                    .font(.minaBody)
                    .foregroundStyle(Color.minaTertiary)
                    .padding(.top, 8)
                    .padding(.horizontal, 4)
            }
            
            // Text editor
            TextEditor(text: $text)
                .font(.minaBody)
                .foregroundStyle(Color.minaPrimary)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused($isFocused)
                .padding(.horizontal, -4) // Offset TextEditor padding
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Keyboard Accessory Bar
// Toolbar that appears above the keyboard matching reference design:
// Normal mode: [🔥 0 (pill)] [mic] [camera] [+] ... [keyboard dismiss]
// Recording mode: [waveform] [checkmark] [x]

struct KeyboardAccessoryBar: View {
    
    let streak: Int
    let isRecording: Bool
    let audioLevels: [CGFloat]
    let liveTranscription: String
    
    var onMicTap: () -> Void
    var onCameraTap: () -> Void
    var onAttachTap: () -> Void
    var onDismissTap: () -> Void
    var onConfirmRecording: () -> Void
    var onCancelRecording: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Live transcription preview (shown while recording)
            if isRecording && !liveTranscription.isEmpty {
                transcriptionPreview
            }
            
            // Main accessory bar
            HStack(spacing: 12) {
                if isRecording {
                    // Recording mode UI
                    recordingModeContent
                } else {
                    // Normal mode UI
                    normalModeContent
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.minaCardSolid)
        }
        .animation(.easeInOut(duration: 0.2), value: isRecording)
        .animation(.easeInOut(duration: 0.15), value: liveTranscription)
    }
    
    // MARK: - Transcription Preview
    
    private var transcriptionPreview: some View {
        HStack {
            Text(liveTranscription)
                .font(.minaBody)
                .foregroundStyle(Color.minaSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.minaBackground)
        .overlay(
            Rectangle()
                .fill(Color.minaDivider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Normal Mode Content
    
    private var normalModeContent: some View {
        Group {
            // Streak pill (elongated capsule)
            streakPill
            
            // Action buttons (circles)
            actionButton(icon: "mic.fill", color: .purple) {
                onMicTap()
            }
            
            actionButton(icon: "camera.fill", color: .purple) {
                onCameraTap()
            }
            
            actionButton(icon: "plus", color: .purple) {
                onAttachTap()
            }
            
            Spacer()
            
            // Keyboard dismiss (just icon, no circle)
            Button(action: onDismissTap) {
                Image(systemName: "keyboard.chevron.compact.down")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.minaSecondary)
            }
        }
    }
    
    // MARK: - Recording Mode Content
    
    private var recordingModeContent: some View {
        Group {
            // Waveform visualizer in capsule
            waveformCapsule
            
            // Confirm button (green checkmark)
            Button(action: onConfirmRecording) {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.minaSuccess)
                    .frame(width: 44, height: 44)
                    .background(Color.minaBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.minaSuccess.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Cancel button (red X)
            Button(action: onCancelRecording) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.minaError)
            }
        }
    }
    
    // MARK: - Waveform Capsule
    
    private var waveformCapsule: some View {
        HStack(spacing: 2) {
            ForEach(0..<audioLevels.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.minaSecondary)
                    .frame(width: 2, height: max(4, audioLevels[index] * 24))
            }
        }
        .frame(height: 24)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.minaBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.minaDivider, lineWidth: 1)
        )
    }
    
    // MARK: - Streak Pill
    
    private var streakPill: some View {
        HStack(spacing: 6) {
            Text("🔥")
                .font(.system(size: 14))
            
            Text("\(streak)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.minaPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.minaBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.minaDivider, lineWidth: 1)
        )
    }
    
    // MARK: - Action Button
    
    private func actionButton(
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color.opacity(0.8))
                .frame(width: 44, height: 44)
                .background(Color.minaBackground)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.minaDivider, lineWidth: 1)
                )
        }
    }
}

// MARK: - Waveform View (Standalone)
// Can be used outside the accessory bar if needed

struct WaveformView: View {
    let levels: [CGFloat]
    let barColor: Color
    let barWidth: CGFloat
    let spacing: CGFloat
    let maxHeight: CGFloat
    
    init(
        levels: [CGFloat],
        barColor: Color = .secondary,
        barWidth: CGFloat = 2,
        spacing: CGFloat = 2,
        maxHeight: CGFloat = 24
    ) {
        self.levels = levels
        self.barColor = barColor
        self.barWidth = barWidth
        self.spacing = spacing
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<levels.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: barWidth / 2)
                    .fill(barColor)
                    .frame(width: barWidth, height: max(4, levels[index] * maxHeight))
            }
        }
        .frame(height: maxHeight)
    }
}

// MARK: - Preview

#Preview("Normal Mode") {
    VStack {
        Spacer()
        
        KeyboardAccessoryBar(
            streak: 7,
            isRecording: false,
            audioLevels: [],
            liveTranscription: "",
            onMicTap: {},
            onCameraTap: {},
            onAttachTap: {},
            onDismissTap: {},
            onConfirmRecording: {},
            onCancelRecording: {}
        )
    }
    .background(Color.minaBackground)
}

#Preview("Recording Mode") {
    VStack {
        Spacer()
        
        KeyboardAccessoryBar(
            streak: 7,
            isRecording: true,
            audioLevels: (0..<30).map { _ in CGFloat.random(in: 0.2...1.0) },
            liveTranscription: "Hello, this is a test of speech recognition...",
            onMicTap: {},
            onCameraTap: {},
            onAttachTap: {},
            onDismissTap: {},
            onConfirmRecording: {},
            onCancelRecording: {}
        )
    }
    .background(Color.minaBackground)
}

#Preview("Inline Editor") {
    struct PreviewWrapper: View {
        @State var text = ""
        @FocusState var focused: Bool
        
        var body: some View {
            VStack {
                InlineEditorView(
                    text: $text,
                    placeholder: "Start logging your meals...",
                    isFocused: $focused
                )
                .frame(height: 200)
                
                Spacer()
            }
            .background(Color.minaBackground)
            .onAppear { focused = true }
        }
    }
    
    return PreviewWrapper()
}
