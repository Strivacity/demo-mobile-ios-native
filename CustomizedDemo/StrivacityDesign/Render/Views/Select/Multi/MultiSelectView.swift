import SdkMobileIOSNative
import SwiftUI

struct MultiSelectView: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let widgetId: String

    let widget: MultiSelectWidget
    let fieldId: String

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widgetId) ?? ""

        VStack(alignment: .leading) {
            Text(widget.label)

            ForEach(widget.options, id: \.self) { option in
                SelectOption(
                    fieldId: fieldId,
                    option: option,
                    selectedValues: loginController.bindingForWidget(
                        formId: formId,
                        widgetId: widgetId,
                        defaultValue: widget.value
                    )
                ).cornerRadius(Typography.borderRadius)
            }.frame(maxWidth: .infinity, alignment: .leading)

        }.padding(.horizontal, Typography.paddingMd)

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }

    struct SelectOption: View {
        let fieldId: String
        var option: MultiSelectWidget.Option
        @Binding var selectedValues: [String?]
        @EnvironmentObject var focusManager: FocusManager

        public var body: some View {
            HStack {
                Group {
                    Button {
                        focusManager.setFocus(to: fieldId + "-" + option.value)
                        if let index = selectedValues.firstIndex(of: option.value) {
                            selectedValues.remove(at: index)
                        } else {
                            selectedValues.append(option.value)
                        }
                    } label: {
                        Image(systemName: selectedValues
                            .contains(option.value) ? "checkmark.rectangle.fill" : "rectangle")
                            .resizable()
                            .frame(width: Typography.iconSizeMd, height: Typography.iconSizeMd)
                            .foregroundColor(Colors.styPrimary)

                        Text(option.label)
                            .padding(.vertical, Typography.paddingMd)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(selectedValues.contains(option.value) ? Colors.styPrimary : .black)
                    }
                }.padding(.horizontal, Typography.paddingMd)
            }
            .background(selectedValues.contains(option.value) ?
                Colors.selectedPrimary.opacity(Typography.selectedItemOpacity) : Color.clear)
        }
    }
}
