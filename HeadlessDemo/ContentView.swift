import SwiftUI
import SdkMobileIOSNative

struct ContentView: View {

    var nativeSDK: NativeSDK

    @State var loading: Bool = true
    @ObservedObject var session: Session
    @State var error: String?
    @State var accessToken: String?

    init() {
        nativeSDK = NativeSDK(
            issuer: URL(string: "https://example.org")!,
            clientId: "",
            redirectURI: URL(string: "strivacity.DemoMobileIOS://native-flow")!,
            postLogoutURI: URL(string: "strivacity.DemoMobileIOS://native-flow")!,
            mode: .iosMinimal
        )

        session = nativeSDK.session
    }

    var body: some View {
        VStack {
            if loading {
                Text("loading...")
            } else {
                Text("Strivacity")

                Spacer()

                if let profile = session.profile {
                    Text("Authenticated: ")
                    Text(profile.claims["given_name"] as? String ?? "N/A")

                    if let accessToken = accessToken {
                        Text("Access token: \(accessToken)")
                    } else {
                        Button("Get access token") {
                            Task {
                                accessToken = try? await nativeSDK.getAccessToken()
                            }
                        }
                    }

                    Button("Logout") {
                        Task {
                            try await nativeSDK.logout()
                        }
                    }
                } else if session.loginInProgress {
                    LoginScreen(nativeSDK: nativeSDK)
                } else {
                    Button("Login") {
                        Task {
                            self.error = nil
                            await nativeSDK.login(
                                parameters: LoginParameters(
                                    scopes: ["openid", "profile", "offline"],
                                    prefersEphemeralWebBrowserSession: true
                                ),
                                onSuccess: {
                                },
                                onError: { err in
                                    switch err {
                                    case let NativeSDKError.oidcError(error: _, errorDescription: errorDescription):
                                        self.error = errorDescription
                                    case NativeSDKError.hostedFlowCanceled:
                                        self.error = "Hosted login canceled"
                                    case NativeSDKError.sessionExpired:
                                        self.error = "Session expired"
                                    default:
                                        print(err)
                                        self.error = "N/A"
                                    }
                                }
                            )
                        }
                    }
                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                    }

                }

                Spacer()

                Text("Footer")
            }
        }
        .onAppear {
            Task {
                try await nativeSDK.initializeSession()
                loading = false
            }
        }
    }
}
