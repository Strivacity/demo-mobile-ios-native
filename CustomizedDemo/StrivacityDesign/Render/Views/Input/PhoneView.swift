import SdkMobileIOSNative
import SwiftUI

struct PhoneView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: PhoneWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        FocusableInputView(
            text: loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: ""),
            label: widget.label,
            required: widget.validator?.required ?? false,
            inputType: .phone,
            fieldId: fieldId,
            error: error
        ).textContentType(.telephoneNumber)
            .keyboardType(.phonePad)

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }
}
