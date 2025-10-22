import UIKit
import SdkMobileIOSNative

class IdentificationViewController: ScreenViewController {

    @IBOutlet weak var identifier: UITextField!
    @IBOutlet weak var identifierError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshScreen()
    }

    override func refreshScreen() {
        identifierError.text = headlessAdapter.errorMessage(formId: "identifier", widgetId: "identifier")
        identifierError.isHidden = identifierError.text == nil
    }

    @IBAction func onContinue(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "identifier", data: ["identifier": identifier.text ?? ""])
        }
    }

    @IBAction func onSignup(_ sender: Any) {
        Task { @MainActor in
            await headlessAdapter.submit(formId: "additionalActions/registration", data: nil)
        }
    }

}
