import SwiftUI
import SdkMobileIOSNative

struct MfaMethodView: View {
    @EnvironmentObject var loginScreenModel: LoginScreenModel

    @State var id: String = ""
    @State var rememberDevice: Bool = false

    var identifier: String {
       loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "reset" })?
            .widgets
            .first(where: { $0.id == "identifier" })?
            .title ?? ""
    }

    var options: [SelectWidget.Option] {
        let idWidget = loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaMethod" })?
            .widgets
            .first(where: { $0.id == "id" })

        return switch idWidget {
        case .select(let selectWidget):
            selectWidget.options
        default:
            []
        }
    }

    var rememberLabel: String {
        let rememberWidget = loginScreenModel
            .screen?
            .forms?
            .first(where: { $0.id == "mfaMethod" })?
            .widgets
            .first(where: { $0.id == "rememberDevice" })

        return switch rememberWidget {
        case .checkbox(let checkboxWidget):
            checkboxWidget.label
        default:
            "Remember this device"
        }
    }

    var body: some View {
        VStack {
            Text("Choose a multi-factor method")
                .font(.title)
                .bold()

            HStack {
                Text(identifier)
                Button("Not you?") {
                    Task {
                        await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                    }
                }
            }

            ForEach(options, id: \.label) { option in
                Text(option.label ?? "N\\A")

                ForEach(option.options ?? [], id: \.value) { item in
                    Toggle(item.label ?? "N/A", isOn: Binding(get: { id == item.value }, set: { _ in id = item.value! }))
                }
            }

            Toggle(rememberLabel, isOn: $rememberDevice)

            Button("Continue") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "mfaMethod", data: ["id": id, "rememberDevice": rememberDevice])
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.primaryAction)

            Button("Back to login") {
                Task {
                    await loginScreenModel.headlessAdapter.submit(formId: "reset", data: [:])
                }
            }

        }
        .onAppear {
            rememberDevice = loginScreenModel
                .screen?
                .forms?
                .first(where: { $0.id == "mfaMethod" })?
                .widgets
                .first(where: { $0.id == "rememberDevice" })?
                .value as? Bool ?? false
        }
    }
}
