import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    let label: String
    let required: Bool
    let fieldId: String
    var error: String

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            InputLabel(label: label, required: required, text: text, isFocused: isFocused, error: error)
            TextField("", text: $text)
                .focusField(fieldId: fieldId, isFocused: _isFocused)
                .a11y(label: label)
                .padding(.top, Typography.paddingMd)
        }
        .frame(height: Typography.inputFrameHeight)
        .padding(.horizontal, Typography.paddingMd)
        .overlay(
            RoundedRectangle(cornerRadius: Typography.borderRadius)
                .stroke(strokeBorderColor(isFocused, error: error), lineWidth: Typography.borderWidthSm)
        )
        .padding(.horizontal, Typography.paddingMd)
    }
}
