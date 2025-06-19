import SdkMobileIOSNative
import SwiftUI

struct CheckboxView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: CheckboxWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        CheckField(widgetId: widgetId, widget: widget, fieldId: fieldId,
                   isOn: loginController.bindingForWidget(
                       formId: formId,
                       widgetId: widgetId,
                       defaultValue: widget.value
                   ))
                   .padding(.horizontal, Typography.paddingMd)

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }

    struct CheckField: View {
        // periphery:ignore - can't resolve the use of widgetId in the onAppear hook
        let widgetId: String
        let widget: CheckboxWidget
        let fieldId: String

        @State var htmlContentValue: String = ""
        @Binding var isOn: Bool
        @EnvironmentObject var focusManager: FocusManager

        public var body: some View {
            HStack {
                Group {
                    if widget.render.labelType == "html" {
                        HtmlTextView(htmlContent: $htmlContentValue)
                            .onAppear {
                                htmlContentValue = widget.label
                            }
                            .onChange(of: widget.label) { _, newLabel in
                                htmlContentValue = newLabel
                            }
                    } else if widget.render.labelType == "text" {
                        Text(widget.label)
                    } else {
                        FallbackTriggerView()
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)

                if widget.render.type == "checkboxShown" {
                    Toggle(isOn: $isOn) {}
                        .tint(Colors.styPrimary)
                        .fixedSize()
                        .onTapGesture {
                            focusManager.setFocus(to: fieldId)
                        }
                } else if widget.render.type == "checkboxHidden" {
                    VStack {}.onAppear {
                        isOn = true
                    }
                } else {
                    FallbackTriggerView()
                }
            }
        }
    }
}
