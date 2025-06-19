import SdkMobileIOSNative
import SwiftUI

struct InputView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: InputWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        let textContentType: UITextContentType? = switch widget.autocomplete {
        case "username":
            .username
        default:
            .none
        }

        let keyboardType: UIKeyboardType = switch widget.inputmode {
        case "email":
            .emailAddress
        default:
            .default
        }

        FocusableInputView(
            text: loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: ""),
            label: widget.label,
            required: widget.validator.required,
            inputType: .textField,
            fieldId: fieldId,
            error: error
        )
        .textContentType(textContentType)
        .keyboardType(keyboardType)

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }
}
