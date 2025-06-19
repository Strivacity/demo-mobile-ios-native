import SdkMobileIOSNative
import SwiftUI

struct GroupSelect: View {
    let formId: String
    let fieldId: String
    let widget: SelectWidget
    @State private var showOptions = false
    @Binding var selectedValue: String?
    @EnvironmentObject var loginController: LoginController

    var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widget.id) ?? ""

        SelectField(
            fieldId: fieldId,
            widget: widget,
            showOptions: $showOptions,
            selectedValue: $selectedValue,
            error: error
        ).sheet(isPresented: $showOptions) {
            GroupSheet(
                fieldId: fieldId,
                widgetOptions: widget.options,
                selectedValue: $selectedValue,
                isPresented: $showOptions
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

struct GroupSheet: View {
    let fieldId: String
    let widgetOptions: [SelectWidget.Option]
    @Binding var selectedValue: String?
    @Binding var isPresented: Bool
    @EnvironmentObject var focusManager: FocusManager

    var body: some View {
        List {
            ForEach(widgetOptions, id: \.self) { option in
                Section(header: Text(option.label!)) {
                    OptionButtons(
                        options: option.options!,
                        selectedValue: $selectedValue,
                        isPresented: $isPresented
                    )
                }
            }
        }

        Button("Cancel") {
            DispatchQueue.main.async {
                isPresented = false
                focusManager.isFocusDisabled = false
                focusManager.setFocus(to: fieldId)
            }
        }.padding()
    }
}

struct OptionButtons: View {
    let options: [SelectWidget.Option]
    @Binding var selectedValue: String?
    @Binding var isPresented: Bool
    @EnvironmentObject var focusManager: FocusManager

    var body: some View {
        ForEach(options, id: \.self) { option in
            Button {
                selectedValue = option.value
                isPresented = false
                focusManager.isFocusDisabled = false
            } label: {
                Text(option.label!)
                    .padding()
                    .foregroundColor(selectedValue == option.value ? Colors.styPrimary : Colors.placeHolder)
                    .background(option.value == selectedValue ? Colors.selectedPrimary
                        .opacity(Typography.selectedItemOpacity) : Color.clear)
                    .cornerRadius(Typography.borderRadius)
            }
        }
    }
}
