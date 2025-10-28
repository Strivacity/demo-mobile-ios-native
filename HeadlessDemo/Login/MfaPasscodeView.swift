import SwiftUI
import SdkMobileIOSNative

struct MfaPasscodedView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var passcode: String = ""

    var subtitle: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaPasscode" })?
            .widgets
            .first(where: { $0.id == "we-sent-a-passcode-to" })?
            .title ?? ""
    }

    var didntReceived: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "additionalActions/resend" })?
            .widgets
            .first(where: { $0.id == "resend-text" })?
            .title ?? ""
    }

    var passcodeLabel: String {
       let passcodeWidget = loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaPasscode" })?
            .widgets
            .first(where: { $0.id == "passcode" })

        return switch passcodeWidget {
        case .passcode(let passcodeWidget):
            passcodeWidget.label
        default:
            "Passcode"
        }
    }


    var body: some View {
        VStack {
            Text("Enter passcode")
                .font(.largeTitle)
                .bold()

            Text(subtitle)

            TextField(passcodeLabel, text: $passcode)
            if let error = loginScreenModel.headlessAdapter.errorMessage(formId: "mfaPasscode", widgetId: "passcode") {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Confirm") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "mfaPasscode", data: [
                        "passcode": passcode
                    ])
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.primaryAction)

            HStack {
                Text(didntReceived)
                Button("Resend") {
                    Task {
                        await loginScreenModel.headlessAdapter.submit(formId: "additionalActions/resend", data: [:])
                    }
                }
            }

            Button("Back to login") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                }
            }

        }
    }
}
