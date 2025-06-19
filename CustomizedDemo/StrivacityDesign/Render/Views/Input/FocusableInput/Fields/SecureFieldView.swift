import SwiftUI

struct SecureFieldView: View {
    @Binding var text: String
    @State var isPasswordVisible: Bool = false
    let label: String
    let fieldId: String
    var error: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                InputLabel(label: label, required: true, text: text, isFocused: isFocused, error: error)
                Group {
                    if isPasswordVisible {
                        TextField("", text: $text)
                    } else {
                        SecureField("", text: $text)
                    }
                }.focusField(fieldId: fieldId, isFocused: _isFocused)
                    .a11y(label: label)
                    .autocapitalization(.none)
                    .padding(.top, Typography.paddingMd)
            }
            .frame(height: Typography.inputFrameHeight)
            .padding(.horizontal, Typography.paddingMd)

            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .resizable()
                    .foregroundColor(.gray)
                    // explicitly set frame size, because the 2 image isn't the same size and caused flickering
                    .frame(width: Typography.iconSizeMd, height: Typography.iconSizeSm)
            }.padding(.horizontal, Typography.paddingSm)
        }
        .overlay(
            RoundedRectangle(cornerRadius: Typography.borderRadius)
                .stroke(strokeBorderColor(isFocused, error: error), lineWidth: Typography.borderWidthSm)
        )
        .padding(.horizontal, Typography.paddingMd)
    }
}
