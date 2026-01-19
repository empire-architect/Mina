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
// [🔥 0 (pill)] [mic] [camera] [+] ... [keyboard dismiss]

struct KeyboardAccessoryBar: View {
    
    let streak: Int
    var onMicTap: () -> Void
    var onCameraTap: () -> Void
    var onAttachTap: () -> Void
    var onDismissTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.minaCardSolid)
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

// MARK: - Keyboard Accessory Modifier
// Attaches the accessory bar above the keyboard

struct KeyboardAccessoryModifier: ViewModifier {
    
    let streak: Int
    let isVisible: Bool
    var onMicTap: () -> Void
    var onCameraTap: () -> Void
    var onAttachTap: () -> Void
    var onDismissTap: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardAccessoryBar(
                        streak: streak,
                        onMicTap: onMicTap,
                        onCameraTap: onCameraTap,
                        onAttachTap: onAttachTap,
                        onDismissTap: onDismissTap
                    )
                    .padding(.horizontal, -16) // Extend to edges
                }
            }
    }
}

extension View {
    func keyboardAccessory(
        streak: Int,
        isVisible: Bool,
        onMicTap: @escaping () -> Void,
        onCameraTap: @escaping () -> Void,
        onAttachTap: @escaping () -> Void,
        onDismissTap: @escaping () -> Void
    ) -> some View {
        modifier(
            KeyboardAccessoryModifier(
                streak: streak,
                isVisible: isVisible,
                onMicTap: onMicTap,
                onCameraTap: onCameraTap,
                onAttachTap: onAttachTap,
                onDismissTap: onDismissTap
            )
        )
    }
}

// MARK: - Preview

#Preview("Keyboard Accessory Bar") {
    VStack {
        Spacer()
        
        KeyboardAccessoryBar(
            streak: 7,
            onMicTap: {},
            onCameraTap: {},
            onAttachTap: {},
            onDismissTap: {}
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
