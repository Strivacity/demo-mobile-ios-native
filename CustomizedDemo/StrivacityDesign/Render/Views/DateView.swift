import SdkMobileIOSNative
import SwiftUI

struct DateView: View {
    let formId: String
    let widgetId: String

    let widget: DateWidget
    let fieldId: String

    @EnvironmentObject var loginController: LoginController

    @State private var showCalendar = false
    @State private var selectedDate = Date()

    @State private var day: String = ""
    @State private var month: String = ""
    @State private var year: String = ""

    public var body: some View {
        let error = loginController.errorMessage(formId: formId, widgetId: widget.id) ?? ""

        if widget.render.type == "native" {
            DateField(widget: widget, formId: formId, fieldId: fieldId, error: error,
                      showCalendar: $showCalendar, selectedDate: loginController.bindingForWidget(
                          formId: formId,
                          widgetId: widgetId,
                          defaultValue: widget.value ?? nil
                      )).onAppear {
                if widget.value != nil {
                    selectedDate = convertStringToDate(widget.value!)!
                }
            }

            .sheet(isPresented: $showCalendar, onDismiss: {
                showCalendar = false
            }) {
                VStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: Locale.preferredLanguages.first ?? "en_US"))
                        .padding()

                    Button("OK") {
                        loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: "")
                            .wrappedValue = convertDateToString(selectedDate)
                        showCalendar = false
                    }
                    .padding()
                }
                .presentationDetents([.fraction(2 / 5)])
                .presentationDragIndicator(.visible)
            }

        } else if widget.render.type == "fieldSet" {
            HStack(spacing: 0) {
                Text(widget.label ?? "Date field")
                    .foregroundStyle(error != "" ? Colors.red : Colors.placeHolder)

                if widget.validator?.required == false {
                    Text(" (Optional)")
                        .font(.caption2)
                }
            }.padding(.horizontal, Typography.paddingMd)
                .padding(.bottom, Typography.paddingSm)

            HStack {
                let dateOrder = getLocalizedDateOrder()
                ForEach(dateOrder, id: \.self) { component in
                    if component == "day" {
                        FocusableInputView(
                            text: $day,
                            label: "Day",
                            required: true,
                            inputType: .textField,
                            fieldId: fieldId + "day",
                            error: error
                        ).keyboardType(.numberPad)
                            .onChange(of: day) { updateDateBinding() }
                    } else if component == "month" {
                        FocusableInputView(
                            text: $month,
                            label: "Month",
                            required: true,
                            inputType: .textField,
                            fieldId: fieldId + "month",
                            error: error
                        ).keyboardType(.numberPad)
                            .onChange(of: month) { updateDateBinding() }
                    } else if component == "year" {
                        FocusableInputView(
                            text: $year,
                            label: "Year",
                            required: true,
                            inputType: .textField,
                            fieldId: fieldId + "year",
                            error: error
                        ).keyboardType(.numberPad)
                            .onChange(of: year) { updateDateBinding() }
                    }
                }
            }.onAppear {
                loadExistingDate()
            }

        } else {
            FallbackTriggerView()
        }

        ErrorView(formId: formId, widgetId: widgetId, error: error)
    }

    private func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    private func getLocalizedDateOrder() -> [String] {
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        let format = DateFormatter.dateFormat(fromTemplate: "yMd", options: 0, locale: locale) ?? "yyyy-MM-dd"

        let components = [("year", "y"), ("month", "M"), ("day", "d")]

        let orderedComponents = components
            .compactMap { name, symbol -> (String, Int)? in
                if let index = format.firstIndex(of: Character(symbol)) {
                    return (name, format.distance(from: format.startIndex, to: index))
                }
                return nil
            }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }

        return orderedComponents
    }

    private func updateDateBinding() {
        var formattedDate: String? = "\(year)-\(month)-\(day)"
        if year.isEmpty && month.isEmpty && day.isEmpty {
            formattedDate = nil
        }
        loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: "")
            .wrappedValue = formattedDate
    }

    private func loadExistingDate() {
        let dateString = loginController.bindingForWidget(formId: formId, widgetId: widgetId, defaultValue: "")
            .wrappedValue ?? ""
        let components = dateString.split(separator: "-").map(String.init)

        if components.count == 3 {
            year = components[0]
            month = components[1]
            day = components[2]
        }
    }
}

private struct DateField: View {
    let widget: DateWidget
    let formId: String
    let fieldId: String
    let error: String

    @Binding var showCalendar: Bool
    @Binding var selectedDate: String?

    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var focusManager: FocusManager

    public var body: some View {
        Button {
            showCalendar.toggle()
            focusManager.setFocus(to: fieldId)
        }
        label: {
            HStack {
                VStack(alignment: .leading) {
                    DateLabel(
                        widget: widget,
                        label: widget.label ?? "Date field",
                        error: error,
                        dateValue: $selectedDate
                    )
                }

                Spacer()

                Button {
                    selectedDate = nil
                    loginController.bindingForWidget(formId: formId, widgetId: widget.id, defaultValue: "")
                        .wrappedValue = nil
                } label: {
                    if selectedDate != nil {
                        Image(systemName: "xmark")
                            .foregroundColor(Colors.placeHolder)
                            .padding(.horizontal, Typography.paddingSm)
                    }
                }
                Image(systemName: "calendar")
                    .foregroundColor(Colors.styPrimary)

            }.frame(height: Typography.inputFrameHeight)
                .padding(.horizontal, Typography.paddingMd)
                .overlay(
                    RoundedRectangle(cornerRadius: Typography.borderRadius)
                        .stroke(getBorderColor(error), lineWidth: 1)
                )
                .padding(.horizontal, Typography.paddingMd)
        }
    }

    private func getBorderColor(_ error: String) -> Color {
        if error != "" {
            return Colors.red
        } else if error == "" && focusManager.isFocused(fieldId) {
            return Colors.styPrimary
        } else {
            return Colors.borderGray
        }
    }
}

private struct DateLabel: View {
    let widget: DateWidget
    let label: String
    let error: String

    @Binding var dateValue: String?
    @State var dateLabel: String?

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .foregroundStyle(error != "" ? Colors.red : Colors.placeHolder)

            if widget.validator?.required == false {
                Text(" (Optional)")
                    .font(.caption2)
            }
        }.offset(y: dateLabel == nil ? Typography.paddingSm : 0)
            .scaleEffect(dateLabel == nil ? Typography.scaleMd : Typography.scaleSm, anchor: .leading)
            .foregroundStyle(Colors.placeHolder)
            .animation(.default, value: dateValue)
            .onAppear {
                dateLabel = widget.label
            }
            .onChange(of: dateValue) {
                if dateValue == nil {
                    dateLabel = nil
                } else {
                    dateLabel = widget.label
                }
            }

        Text((dateValue == nil ? dateLabel : formatDate(dateValue!)) ?? "")
            .foregroundColor(Colors.placeHolder)
    }

    private func formatDate(_ dateString: String) -> String {
        guard let date = convertStringToDate(dateString) else { return dateString }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        formatter.setLocalizedDateFormatFromTemplate("yMd")

        return formatter.string(from: date)
    }
}

private func convertStringToDate(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.date(from: dateString)
}
