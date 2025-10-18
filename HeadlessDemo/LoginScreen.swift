import SwiftUI
import Combine
import SdkMobileIOSNative

struct LoginScreen: View {
    @ObservedObject var loginScreenModel: LoginScreenModel

    init(nativeSDK: NativeSDK) {
        loginScreenModel = LoginScreenModel(nativeSDK: nativeSDK)
        loginScreenModel.headlessAdapter.initialize()
    }

    var body: some View {
        ZStack {
            if loginScreenModel.screen == nil {
                Text("Loading")
            } else {
                switch loginScreenModel.screen?.screen {
                case "identification":
                    IdentificationView()
                case "password":
                    PasswordView()
                default:
                    HeadlessAdapterLoginView(headlessAdapter: loginScreenModel.headlessAdapter)
                }
            }
        }
        .environmentObject(loginScreenModel)
    }
}

class LoginScreenModel: ObservableObject, HeadlessAdapterDelegate {
    var headlessAdapter: HeadlessAdapter!

    @Published var screen: Screen?

    init(nativeSDK: NativeSDK) {
        self.headlessAdapter = HeadlessAdapter(nativeSDK: nativeSDK, delegate: self)
    }

    @MainActor
    public func renderScreen(screen: Screen) {
        DispatchQueue.main.async {
            self.screen = screen
        }
    }

    @MainActor
    public func refreshScreen(screen: Screen) {
        DispatchQueue.main.async {
            self.screen = screen
        }
    }
}
