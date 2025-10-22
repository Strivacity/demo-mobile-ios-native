import UIKit
import SdkMobileIOSNative

class LandingViewController: UIViewController {

    var nativeSDK: NativeSDK!
    var loginError: String?

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var error: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.isHidden = true
        loadIndicator.isHidden = false

        error.isHidden = loginError == nil
        error.text = loginError

        Task { @MainActor in
            try! await nativeSDK.initializeSession()
            if (nativeSDK?.session.profile != nil) {
                let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
                mainViewController.nativeSDK = nativeSDK
                navigationController?.setViewControllers([mainViewController], animated: true)
                return
            }

            loginButton.isHidden = false
            loadIndicator.isHidden = true
        }

        view.backgroundColor = .systemBackground
    }

    @IBAction func loginClicked(_ sender: UIButton) {
        print("Login tapped!")

        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.nativeSDK = nativeSDK

        navigationController?.setViewControllers([loginViewController], animated: true)
    }

    private func navigateToMainViewController() {
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        mainViewController.nativeSDK = nativeSDK

        navigationController?.setViewControllers([mainViewController], animated: true)
    }

}
