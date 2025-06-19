import SdkMobileIOSNative
import SwiftUI

struct PasswordWiew: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: PasswordWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        FocusableInputView(
            text: loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: ""),
            label: widget.label,
            required: true,
            inputType: .secureField,
            fieldId: fieldId,
            error: error
        )

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }
}
