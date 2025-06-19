import SdkMobileIOSNative
import SwiftUI

struct SelectField: View {
    let fieldId: String
    let widget: SelectWidget
    @Binding var showOptions: Bool
    @Binding var selectedValue: String?
    let error: String

    @EnvironmentObject var focusManager: FocusManager

    var body: some View {
        Button {
            DispatchQueue.main.async {
                showOptions = true
                focusManager.isFocusDisabled = true
                focusManager.setFocus(to: fieldId)
            }
        }
        label: {
            HStack {
                VStack(alignment: .leading) {
                    if let label = widget.label {
                        SelectLabel(widget: widget, label: label, error: error, selectedValue: $selectedValue)
                    } else {
                        SelectLabel(
                            widget: widget,
                            label: widget.options[0].label!,
                            error: error,
                            selectedValue: $selectedValue
                        )
                    }
                }

                Spacer()

                Button {
                    selectedValue = nil
                } label: {
                    if selectedValue != nil && !widget.validator.required {
                        Image(systemName: "xmark")
                            .foregroundColor(Colors.placeHolder)
                            .padding(.horizontal, Typography.paddingSm)
                    }
                }
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(Colors.styPrimary)

            }.frame(height: Typography.inputFrameHeight)
                .padding(.horizontal, Typography.paddingMd)
                .overlay(
                    RoundedRectangle(cornerRadius: Typography.borderRadius)
                        .stroke(getBorderColor(showOptions, error), lineWidth: 1)
                )
                .padding(.horizontal, Typography.paddingMd)
        }
    }

    private func getBorderColor(_ showOptions: Bool, _ error: String) -> Color {
        if error != "" && !showOptions {
            return Colors.red
        } else if error == "" && showOptions {
            return Colors.styPrimary
        } else if focusManager.isFocused(fieldId) {
            return Colors.styPrimary
        } else {
            return Colors.borderGray
        }
    }

    private struct SelectLabel: View {
        let widget: SelectWidget
        let label: String
        let error: String

        @Binding var selectedValue: String?
        @State var selectedLabel: String?

        var body: some View {
            HStack(spacing: 0) {
                Text(label)
                    .foregroundStyle(error != "" ? Colors.red : Colors.placeHolder)

                if !widget.validator.required {
                    Text(" (Optional)")
                        .font(.caption2)
                }
            }.offset(y: selectedLabel == nil ? Typography.paddingSm : 0)
                .scaleEffect(selectedLabel == nil ? Typography.scaleMd : Typography.scaleSm, anchor: .leading)
                .foregroundStyle(Colors.placeHolder)
                .animation(.default, value: selectedValue)
                .onAppear {
                    setSelectedLabel(widget.options)
                }
                .onChange(of: selectedValue) {
                    if selectedValue == nil {
                        selectedLabel = nil
                    } else {
                        setSelectedLabel(widget.options)
                    }
                }

            Text(selectedLabel ?? "")
                .foregroundColor(Colors.placeHolder)
        }

        private func setSelectedLabel(_ options: [SelectWidget.Option]) {
            for option in options {
                if option.value == selectedValue {
                    selectedLabel = option.label
                    return
                }
                if let nestedOptions = option.options {
                    setSelectedLabel(nestedOptions)
                }
            }
        }
    }
}
