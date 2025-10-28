import SwiftUI
import SdkMobileIOSNative

struct MfaEnrollTargetSelectView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var target: String = ""

    var title: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaEnrollTargetSelect" })?
            .widgets
            .first(where: { $0.id == "section-title" })?
            .title ?? ""
    }

    var targetLabel: String {
       let targetWidget = loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaEnrollTargetSelect" })?
            .widgets
            .first(where: { $0.id == "target" })

        return switch targetWidget {
        case .select:
            "Email address"
        case .input(let inputWidget):
            inputWidget.label
        case .phone:
            "Phone number"
        default:
            "Email address"
        }
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()

            TextField(targetLabel, text: $target)
            if let error = loginScreenModel.headlessAdapter.errorMessage(formId: "mfaEnrollTargetSelect", widgetId: "target") {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Verify") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "mfaEnrollTargetSelect", data: [
                        "target": target,
                        "method": "passcode"
                    ])
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.primaryAction)

            Button("Select different method to enroll") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "additionalActions/selectDifferentMethod", data: [:])
                }
            }

            Button("Back to login") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                }
            }
        }
        .onAppear {
            target = loginScreenModel
                .screen?
                .forms?
                .first(where: { $0.id == "mfaEnrollTargetSelect" })?
                .widgets
                .first(where: { $0.id == "target" })?
                .value as! String? ?? ""
        }
    }
}
