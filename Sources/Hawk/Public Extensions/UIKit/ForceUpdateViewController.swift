import UIKit

/**
 * A protocol that defines the requirements for a custom force update view controller.
 * Implement this protocol to create your own custom update dialog.
 */
@MainActor
public protocol ForceUpdateViewController {
    /**
     * Creates and returns a view controller that represents the force update dialog.
     * This is the main method that clients should call to get the dialog view controller.
     *
     * - Returns: A view controller that will be presented as the force update dialog.
     */
    func makeForceUpdateDialog() -> UIViewController

    /**
     * Opens the App Store to update the app.
     */
    func openAppStore()
}

/**
 * Default implementation for the ForceUpdateViewController protocol.
 */
extension ForceUpdateViewController {
    /**
     * Default implementation to open the App Store.
     */
    public func openAppStore() {
        if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
           let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
            UIApplication.shared.open(url)
        }
    }

    /**
     * Configures the view controller with alert-like presentation style.
     * This is an internal helper method used by implementations.
     *
     * - Parameter viewController: The view controller to configure.
     */
    func configureForAlertPresentation(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
    }
}
