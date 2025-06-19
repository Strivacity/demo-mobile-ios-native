import SdkMobileIOSNative
import SwiftUI

struct FocusField: ViewModifier {
    @EnvironmentObject var focusManager: FocusManager
    @FocusState var isFocused: Bool
    let fieldId: String

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .simultaneousGesture(TapGesture().onEnded {
                DispatchQueue.main.async {
                    focusManager.setFocus(to: fieldId)
                    isFocused = focusManager.isFocused(fieldId)
                }
            })
            .onChange(of: focusManager.focusedField) {
                DispatchQueue.main.async {
                    isFocused = focusManager.isFocused(fieldId)
                }
            }
    }
}

extension View {
    func focusField(fieldId: String, isFocused: FocusState<Bool>) -> some View {
        modifier(FocusField(isFocused: isFocused, fieldId: fieldId))
    }
}
