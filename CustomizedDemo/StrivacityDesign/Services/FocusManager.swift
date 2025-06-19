import Foundation

class FocusManager: ObservableObject {
    @Published var focusedField: String?
    @Published var isFocusDisabled: Bool = false

    func isFocused(_ fieldId: String) -> Bool {
        return focusedField == fieldId
    }

    func setFocus(to fieldId: String) {
        focusedField = fieldId
    }

    func clearFocus() {
        focusedField = nil
    }
}
