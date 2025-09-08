import SwiftUI
import SdkMobileIOSNative
import AuthenticationServices

struct WebauthnView: View {
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var scrollManager: ScrollManager
    @EnvironmentObject var focusManager: FocusManager


    let formId: String

    let widget: WebauthnWidget
    @StateObject private var delegate = WebauthnDelegate()
    
   

    public var body: some View {
        let button = Button {
            Task {
                registerPasskey(widget:widget)
                scrollManager.errorFieldIds.removeAll()
                await loginController.submit(formId: formId)
                focusManager.clearFocus()
            }
        } label: { Text(widget.label)
            .frame(maxWidth: widget.render.type == "button" ? .infinity : nil)
            .font(widget.render.type == "button" ? .body.bold() : .body)
            .padding(.vertical, widget.render.type == "button" ? Typography.paddingMd : 0)
        }

        switch widget.render.type {
        case "button":
            let textColor = Color(hex: widget.render.textColor ?? "")
            let bgColor = Color(hex: widget.render.bgColor ?? "")

            button
                .foregroundColor(textColor ?? (widget.render.hint?.variant == "primary" ? .white : Colors
                        .styPrimary))
                .background(bgColor ?? (widget.render.hint?.variant == "primary" ? Colors
                        .styPrimary : .white))
                .cornerRadius(Typography.borderRadius)
                .border(Colors.borderGray, width: 1)
                .padding(.horizontal, Typography.paddingMd)
                .padding(.bottom, Typography.errorFrameHeight)

        default:
            FallbackTriggerView()
        }
        
    }
    
    private func randomChallenge(length: Int = 32) -> Data {
            var bytes = [UInt8](repeating: 0, count: length)
            _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
            return Data(bytes)
        }
    
    private func registerPasskey(widget: WebauthnWidget) {
        print(widget)
        guard let creationOptions = widget.metadata.creationOptions else {
            return
        }
 
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: creationOptions.rp.id
        )
        
        let userId = Data(creationOptions.user.id.utf8)
        let challenge = Data(creationOptions.challenge.utf8)
        let displayName = creationOptions.user.displayName
 
        let request = provider.createCredentialRegistrationRequest(
            challenge: challenge,
            name: displayName,
            userID: userId
        )
         
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = delegate
        controller.performRequests()
    }


    private func loginPasskey(widget:WebauthnWidget) {
        
            guard let assertionOptions = widget.metadata.assertionOptions else {
                return
            }
        
            print(assertionOptions)
        
            let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: widget.metadata.assertionOptions!.rpId
            )
           
            let challenge = Data(assertionOptions.challenge.utf8)
        

            let request = provider.createCredentialAssertionRequest(challenge: challenge)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = delegate
            controller.performRequests()
        }
}

class WebauthnDelegate: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    @Published var authResult: String? = nil
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
            authResult = "Passkey register successfull! Credential ID: \(credential.credentialID.base64EncodedString())"
        } else if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
            authResult = "Passkey login successfull! Credential ID: \(credential.credentialID.base64EncodedString())"
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authResult = "Error: \(error.localizedDescription)"
    }
}

