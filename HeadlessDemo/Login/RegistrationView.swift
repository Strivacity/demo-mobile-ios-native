import SwiftUI
import SdkMobileIOSNative

struct RegistrationView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""

    var externalLoginProviders: [(id: String, name: String)] {
        return self.loginScreenModel
            .screen?
            .forms?
            .filter { $0.id.starts(with: "externalLoginProvider/") }
            .map {
                let label: String = if case .submit(let w) = $0.widgets.first! {  w.label } else { "" }

                return ($0.id as String, label)
            } ?? []
    }

    var body: some View {
        VStack {
            Text("Sign up")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
            if let emailError = loginScreenModel.headlessAdapter.errorMessage(formId: "registration", widgetId: "email") {
                Text(emailError)
                    .foregroundColor(.red)
            }

            SecureField("Password", text: $password)
            if let passwordError = loginScreenModel.headlessAdapter.errorMessage(formId: "registration", widgetId: "password") {
                Text(passwordError)
                    .foregroundColor(.red)
            }

            SecureField("Re-type password", text: $passwordConfirmation)
            if let passwordConfirmationError = loginScreenModel.headlessAdapter.errorMessage(formId: "registration", widgetId: "passwordConfirmation") {
                Text(passwordConfirmationError)
                    .foregroundColor(.red)
            }

            Button("Continue") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "registration", data: [
                        "email": email,
                        "password": password,
                        "passwordConfirmation": passwordConfirmation,
                    ])
                }
            }
            .tint(.primaryAction)
            .buttonStyle(.borderedProminent)

            ForEach(externalLoginProviders, id: \.id) { item in
                Button(item.name) {
                    Task {
                        await loginScreenModel.headlessAdapter.submit(formId: item.id, data: [:])
                    }
                }
                .buttonStyle(.bordered)
                .tint(.primaryAction)
            }

            Button("Back to login") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                }
            }

        }
        .onAppear {
            email = loginScreenModel
                .screen?
                .forms?
                .first(where: { $0.id == "registration" })?
                .widgets
                .first(where: { $0.id == "email" })?
                .value as! String? ?? ""
        }
    }
}
