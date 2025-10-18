import SwiftUI
import SdkMobileIOSNative

struct IdentificationView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var identifier: String = ""

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
            }.buttonStyle(.borderedProminent)

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
