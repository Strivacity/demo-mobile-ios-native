import UIKit
import SwiftUI
import SdkMobileIOSNative

class UnkownViewController: ScreenViewController {

    @IBOutlet weak var swiftUiContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView = HeadlessAdapterLoginView(headlessAdapter: headlessAdapter)
        let hostingController = UIHostingController(rootView: loginView)

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        swiftUiContainer.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: swiftUiContainer.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: swiftUiContainer.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: swiftUiContainer.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: swiftUiContainer.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

}
