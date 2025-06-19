import SdkMobileIOSNative
import SwiftUI

struct SimpleSelect: View {
    let formId: String
    let widget: SelectWidget
    let fieldId: String
    @State private var showOptions = false
    @Binding var selectedValue: String?
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var focusManager: FocusManager

    var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widget.id) ?? ""

        SelectField(
            fieldId: fieldId, widget: widget,
            showOptions: $showOptions,
            selectedValue: $selectedValue,
            error: error
        )
        .actionSheet(isPresented: $showOptions) {
            ActionSheet(
                title: Text(widget.label!),
                buttons: widget.options.map { option in
                    .default(Text(option.label!)) {
                        selectedValue = option.value
                        focusManager.isFocusDisabled = false
                    }
                } + [.cancel {
                    DispatchQueue.main.async {
                        focusManager.isFocusDisabled = false
                        focusManager.setFocus(to: fieldId)
                    }
                }]
            )
        }
        .onAppear {
            if let value = widget.value {
                selectedValue = value
            }
        }

        ErrorView(formId: formId, widgetId: widget.id, error: error)
    }
}
