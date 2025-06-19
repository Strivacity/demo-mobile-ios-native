import SdkMobileIOSNative
import SwiftUI

struct RadioSelect: View {
    @EnvironmentObject var loginController: LoginController

    let formId: String
    let fieldId: String
    let widget: SelectWidget
    @Binding var selectedValue: String?

    var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widget.id) ?? ""

        VStack(alignment: .leading) {
            Group {
                if widget.options[0].options != nil {
                    ForEach(widget.options, id: \.self) { option in
                        Text(widget.label ?? "")

                        if let subOptions = option.options {
                            ForEach(subOptions, id: \.self) { subOption in
                                SelectOption(fieldId: fieldId, option: subOption, selectedValue: $selectedValue)
                                    .cornerRadius(Typography.borderRadius)
                            }
                        }
                    }
                } else {
                    Text(widget.label ?? "")

                    ForEach(widget.options, id: \.self) { option in
                        SelectOption(fieldId: fieldId, option: option, selectedValue: $selectedValue)
                            .cornerRadius(Typography.borderRadius)
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Typography.paddingMd)
        .onAppear {
            if widget.value != nil {
                selectedValue = widget.value
            } else if widget.options.first!.type == "item" {
                selectedValue = widget.options.first?.value
            } else if widget.options.first!.type == "group" {
                selectedValue = widget.options.first?.options?.first?.value
            }
        }.disabled(widget.readonly)

        ErrorView(formId: formId, widgetId: widget.id, error: error)
    }

    struct SelectOption: View {
        let fieldId: String
        var option: SelectWidget.Option
        @Binding var selectedValue: String?
        @EnvironmentObject var focusManager: FocusManager

        var body: some View {
            HStack {
                Group {
                    Button {
                        selectedValue = option.value
                        focusManager.setFocus(to: fieldId + "-" + option.value!)
                    } label: {
                        Image(systemName: selectedValue == option.value ? "record.circle" : "circle")
                            .resizable()
                            .frame(width: Typography.iconSizeMd, height: Typography.iconSizeMd)
                            .foregroundColor(Colors.styPrimary)

                        Text(option.label ?? "")
                            .padding(.vertical, Typography.paddingMd)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(selectedValue == option.value ? Colors.styPrimary : Colors
                                .placeHolder)
                    }
                }.padding(.horizontal, Typography.paddingMd)
            }

            .background(selectedValue == option.value ?
                Colors.selectedPrimary.opacity(Typography.selectedItemOpacity) : Color.clear)
        }
    }
}
