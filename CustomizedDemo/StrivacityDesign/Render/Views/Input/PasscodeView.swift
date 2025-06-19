import SdkMobileIOSNative
import SwiftUI

struct PasscodeView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: PasscodeWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        FocusableInputView(
            text: loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: ""),
            label: widget.label,
            required: true,
            inputType: .passcode,
            fieldId: fieldId,
            error: error
        ).textContentType(.oneTimeCode)
            .keyboardType(.numberPad)

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }
}
