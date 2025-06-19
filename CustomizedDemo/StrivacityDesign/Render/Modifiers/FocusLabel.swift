import SwiftUI

struct FocusLabel: ViewModifier {
    let isFocused: Bool
    let text: String
    let error: String
    @State var hasOnScreen = false

    func body(content: Content) -> some View {
        content
            .offset(y: floatLabel())
            .scaleEffect(scaleLabel(), anchor: .leading)
            .foregroundColor(strokeLabelColor(isFocused))
    }

    private func floatLabel() -> CGFloat {
        if !isFocused && text == "" {
            return 0
        } else {
            return -Typography.paddingMd
        }
    }

    private func scaleLabel() -> CGFloat {
        if !isFocused && text == "" {
            return Typography.scaleMd
        } else {
            return Typography.scaleSm
        }
    }

    private func strokeLabelColor(_ isFocused: Bool) -> Color {
        if error != "" && !isFocused {
            return Colors.red
        } else if isFocused {
            return Colors.styPrimary
        } else {
            return Colors.placeHolder
        }
    }
}

extension View {
    func focusLabel(isFocused: Bool, text: String, error: String) -> some View {
        modifier(FocusLabel(isFocused: isFocused, text: text, error: error))
    }
}
