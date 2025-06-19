import SwiftUI

struct FocusableInputView: View {
    @Binding var text: String
    let label: String
    let required: Bool
    let inputType: InputType
    let fieldId: String
    var error: String

    var body: some View {
        switch inputType {
        case .textField:
            TextFieldView(text: $text, label: label, required: required, fieldId: fieldId, error: error)

        case .secureField:
            SecureFieldView(text: $text, label: label, fieldId: fieldId, error: error)

        case .phone:
            PhoneFieldView(text: $text, label: label, required: required, fieldId: fieldId, error: error)

        case .passcode:
            PasscodeFieldView(text: $text, label: label, required: required, fieldId: fieldId, error: error)
        }
    }

    enum InputType {
        case textField
        case secureField
        case phone
        case passcode
    }
}
