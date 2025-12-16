import SdkMobileIOSNative
import SwiftUI

struct Login: View {
    var nativeSDK: NativeSDK
    @State var error: String?
    @EnvironmentObject var session: Session
    @EnvironmentObject var scrollManager: ScrollManager
    @EnvironmentObject var focusManager: FocusManager

    public var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack {
                        if let profile = session.profile {
                            Text("Authenticated: ")
                            Text(profile.claims["given_name"] as? String ?? "N/A")
                            Button("Revoke") {
                                Task {
                                    try await nativeSDK.revoke()
                                }
                            }
                            Button("Logout") {
                                Task {
                                    try await nativeSDK.logout()
                                }
                            }
                        } else if session.loginInProgress {
                            LoginView(nativeSDK: nativeSDK) { _, screen, forms, layout in
                                WidgetHandler(screen: screen, forms: forms, layout: layout)
                            }.padding()
                                .disabled(focusManager.isFocusDisabled)
                        } else {
                            Button("Login") {
                                Task {
                                    self.error = nil
                                    await nativeSDK.login(
                                        parameters: nil, onSuccess: {}, onError: { err in
                                            switch err {
                                            case let NativeSDKError.oidcError(
                                                error: _,
                                                errorDescription: errorDescription
                                            ):
                                                self.error = errorDescription
                                            case NativeSDKError.hostedFlowCanceled:
                                                self.error = "Hosted flow was cancelled"
                                            case NativeSDKError.sessionExpired:
                                                self.error = "Login session expired"
                                            default:
                                                self.error = "N/A"
                                            }
                                        }
                                    )
                                }
                            }
                            if let error = error {
                                Text(error)
                                    .foregroundColor(Colors.red)
                            }
                        }
                    } // center the scrollview content vertically
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .onChange(of: scrollManager.errorFieldIds) {
                let ids = scrollManager.errorFieldIds
                if ids != [] {
                    withAnimation {
                        proxy.scrollTo(ids[0], anchor: .center)
                    }
                }
            }

            if session.loginInProgress {
                Button {
                    nativeSDK.cancelFlow()
                } label: {
                    Text("Cancel login")
                }.foregroundStyle(Colors.styPrimary)
            }
        }
    }
}
