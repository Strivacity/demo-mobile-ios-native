import SdkMobileIOSNative
import SwiftUI

struct SelectView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: SelectWidget
    let fieldId: String

    public var body: some View {
        if widget.render?.type == "dropdown" {
            if widget.options[0].type == "item" {
                SimpleSelect(
                    formId: formId,
                    widget: widget,
                    fieldId: fieldId,
                    selectedValue: loginController.bindingForWidget(
                        formId: formId,
                        widgetId: widgetId,
                        defaultValue: widget.value ?? nil
                    )
                )
            } else {
                GroupSelect(
                    formId: formId,
                    fieldId: fieldId, widget: widget,
                    selectedValue: loginController.bindingForWidget(
                        formId: formId,
                        widgetId: widgetId,
                        defaultValue: widget.value ?? nil
                    )
                )
            }
        } else if widget.render?.type == "radio" {
            RadioSelect(
                formId: formId,
                fieldId: fieldId,
                widget: widget,
                selectedValue: loginController.bindingForWidget(
                    formId: formId,
                    widgetId: widgetId,
                    defaultValue: widget.value ?? nil
                )
            )
        } else {
            FallbackTriggerView()
        }
    }
}
