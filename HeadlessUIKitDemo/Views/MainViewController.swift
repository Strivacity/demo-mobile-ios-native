import UIKit
import SdkMobileIOSNative

class MainViewController: UIViewController {

    var nativeSDK: NativeSDK!

    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        email.text = nativeSDK.session.profile?.claims["email"] as? String ?? ""
    }
    
    @IBAction func onRevoke(_ sender: Any) {
        Task { @MainActor in
            try! await nativeSDK.revoke()

            let landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
            landingViewController.nativeSDK = nativeSDK

            navigationController?.setViewControllers([landingViewController], animated: true)
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        Task { @MainActor in
            try! await nativeSDK.logout()

            let landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
            landingViewController.nativeSDK = nativeSDK

            navigationController?.setViewControllers([landingViewController], animated: true)
        }
    }

}
