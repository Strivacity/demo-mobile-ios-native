import SdkMobileIOSNative
import SwiftUI

struct InputLabel: View {
    @EnvironmentObject var loginController: LoginController

    var label: String
    var required: Bool
    var text: String
    var isFocused: Bool
    var error: String

    public var body: some View {
        modifyOptionalInputs(label: label)
            .focusLabel(isFocused: isFocused, text: text, error: error)
            .animation(loginController.processing ? .none : .default, value: isFocused)
    }

    @ViewBuilder
    private func modifyOptionalInputs(label: String) -> some View {
        let originalLabel = Text(label)

        let optionalLabel = if required {
            Text("")
        } else {
            Text(" (Optional)")
                .font(.caption2)
                .foregroundColor(Colors.placeHolder)
        }

        HStack(spacing: 0) {
            originalLabel
            optionalLabel
        }
    }
}

func strokeBorderColor(_ isFocused: Bool, error: String) -> Color {
    if error != "" && !isFocused {
        return Colors.red
    } else if isFocused {
        return Colors.styPrimary
    } else {
        return Colors.borderGray
    }
}
