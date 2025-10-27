import SwiftUI
import SdkMobileIOSNative

struct PasswordView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var password: String = ""
    @State var keepMeLoggedIn: Bool = false

    var identifier: String {
        let identifierWidget = loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "reset" })?
            .widgets
            .first(where: { $0.id == "identifier" })!

        switch identifierWidget {
        case .staticWidget(let widget):
            return widget.value
        default:
            return ""
        }
    }

    var body: some View {
        VStack {
            Text("Enter password")
                .font(.largeTitle)
                .bold()

            HStack {
                Text(identifier)
                Button("Not you?") {
                    Task {
                        await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                    }
                }
            }

            SecureField("Enter your password", text: $password)
            if let error = loginScreenModel.headlessAdapter.errorMessage(formId: "password", widgetId: "password") {
                Text(error)
                    .foregroundColor(.red)
            }

            Toggle("Keep me logged in", isOn: $keepMeLoggedIn)

            Button("Continue") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "password", data: ["password": password, "keepMeLoggedIn": keepMeLoggedIn])
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.primaryAction)

            Button("Forgot your password?") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "additionalActions/forgottenPassword", data: [:])
                }
            }

            Button("Back to login") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                }
            }

        }
        .onAppear {
            keepMeLoggedIn = loginScreenModel
                .screen?
                .forms?
                .first(where: { $0.id == "password" })?
                .widgets
                .first(where: { $0.id == "keepMeLoggedIn" })?
                .value as? Bool ?? false
        }
    }
}
