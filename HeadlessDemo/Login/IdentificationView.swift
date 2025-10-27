import SwiftUI
import SdkMobileIOSNative

struct IdentificationView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var identifier: String = ""

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
            Text("Sign in")
                .font(.largeTitle)
                .bold()
            
            TextField("Email address", text: $identifier)

            if let error = loginScreenModel.headlessAdapter.errorMessage(formId: "identifier", widgetId: "identifier") {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Continue") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "identifier", data: ["identifier": identifier])
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

            HStack {
                Text("Don't have an account?")
                Button("Sign up") {
                    Task {
                        await loginScreenModel.headlessAdapter.submit(formId: "additionalActions/registration", data: [:])
                    }
                }
            }

        }
    }
}
