import SwiftUI
import SdkMobileIOSNative

struct GenericResultView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    var title: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "genericResult" })?
            .widgets
            .first(where: { $0.id == "section-title" })?
            .title ?? ""
    }
    var text: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "genericResult" })?
            .widgets
            .first(where: { $0.id == "generic-result-text" })?
            .title ?? ""
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()

            Text(text)

            Button("Continue") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "genericResult", data: [:])
                }
            }
            .tint(.primaryAction)
            .buttonStyle(.borderedProminent)
        }
    }
}
