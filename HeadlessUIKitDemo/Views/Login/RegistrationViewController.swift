import UIKit
import SdkMobileIOSNative

class RegistrationViewController: ScreenViewController {

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var passwordRetype: UITextField!

    @IBOutlet weak var emailError: UILabel!

    @IBOutlet weak var passwordError: UILabel!

    @IBOutlet weak var passwordRetypeError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshScreen()
    }

    override func refreshScreen() {
        emailError.text = headlessAdapter.errorMessage(formId: "registration", widgetId: "email")
        emailError.isHidden = emailError.text == nil

        passwordError.text = headlessAdapter.errorMessage(formId: "registration", widgetId: "password")
        passwordError.isHidden = passwordError.text == nil

        passwordRetypeError.text = headlessAdapter.errorMessage(formId: "registration", widgetId: "passwordConfirmation")
        passwordRetypeError.isHidden = passwordRetypeError.text == nil
    }

    @IBAction func onContinue(_ sender: UIButton) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "registration", data: [
                "email": email.text ?? "",
                "password": password.text ?? "",
                "passwordConfirmation": passwordRetype.text ?? ""
            ])
        }
    }

    @IBAction func onBackToLogin(_ sender: UIButton) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "reset", data: [:])
        }
    }

}
