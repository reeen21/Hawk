import UIKit

public extension UIViewController {

    /// Checks for a forced update at the specified level (major, minor, patch).
    /// If needed, presents an alert prompting the user to update.
    ///
    /// - Parameter level: The update level threshold (default = .minor).
    func showForceUpdateDialogIfNeeded(level: UpdateLevel = .minor) {
        // Run an asynchronous task on the main actor so alert presentation
        // happens on the main thread.
        Task { @MainActor in
            let needsUpdate = await Hawk.checkIsNeedForceUpdate(level: level)
            if needsUpdate {
                presentUpdateAlert()
            }
        }
    }

    /// Presents an alert telling the user a new version is available and prompting them to update.
    private func presentUpdateAlert() {
        let alertController = UIAlertController(
            title: String(localized: "Dialog.Title", bundle: .module),
            message: String(localized: "Dialog.Message", bundle: .module),
            preferredStyle: .alert
        )

        let updateAction = UIAlertAction(title: String(localized: "Dialog.ButtonTitle", bundle: .module), style: .default) { _ in
            // Replace with your real App Store link or logic
            if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
               let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
                UIApplication.shared.open(url)
            }
        }

        alertController.addAction(updateAction)
        present(alertController, animated: true)
    }
}
