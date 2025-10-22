import UIKit
import SdkMobileIOSNative

class PasswordViewController: ScreenViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var keepMeLoggedIn: UISwitch!

    @IBOutlet weak var identifier: UILabel!
    
    @IBOutlet weak var passwordError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keepMeLoggedIn.isOn =
            screen
                .forms?
                .first(where: { $0.id == "password" })?
                .widgets
                .first(where: { $0.id == "keepMeLoggedIn" })?
                .value as? Bool ?? false

        let identifierWidget = screen
            .forms?
            .first(where: { $0.id == "reset" })?
            .widgets
            .first(where: { $0.id == "identifier" })!

        switch identifierWidget {
        case .staticWidget(let widget):
            identifier.text = widget.value
        default:
            break
        }

        refreshScreen()
    }

    override func refreshScreen() {
        passwordError.text = headlessAdapter.errorMessage(formId: "password", widgetId: "password")
        passwordError.isHidden = passwordError.text == nil
    }

    @IBAction func onContinue(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "password", data: [
                "password": password.text ?? "",
                "keepMeLoggedIn": keepMeLoggedIn.isOn
            ])
        }
    }

    @IBAction func onNotYou(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "reset", data: [:])
        }
    }
    
    @IBAction func onForgottenPassword(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "additionalActions/forgottenPassword", data: nil)
        }
    }
    
    @IBAction func onBackToLogin(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "reset", data: [:])
        }
    }

}
