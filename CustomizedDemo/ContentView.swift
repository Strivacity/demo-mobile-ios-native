import SdkMobileIOSNative
import SwiftUI

struct ContentView: View {
    var nativeSDK: NativeSDK

    @State var loading: Bool = true
    @State var error: String?
    @ObservedObject var session: Session
    @ObservedObject var scrollManager = ScrollManager()
    @ObservedObject var focusManager = FocusManager()

    init() {
        nativeSDK = NativeSDK(
            issuer: URL(string: "https://example.org")!,
            clientId: "",
            redirectURI: URL(string: "strivacity.DemoMobileIOS://native-flow")!,
            postLogoutURI: URL(string: "strivacity.DemoMobileIOS://native-flow")!
        )

        session = nativeSDK.session
    }

    var body: some View {
        VStack {
            if loading {
                Text("loading...")
            } else {
                Text("Strivacity")
                    .padding(.top, 24)

                Login(nativeSDK: nativeSDK, error: error)
                    .environmentObject(session)
                    .environmentObject(scrollManager)
                    .environmentObject(focusManager)

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

#Preview {
    ContentView()
}
