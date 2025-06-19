import SwiftUI

struct A11Y: ViewModifier {
    let label: String

    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .disableAutocorrection(true)
    }
}

extension View {
    func a11y(label: String) -> some View {
        modifier(A11Y(label: label))
    }
}
