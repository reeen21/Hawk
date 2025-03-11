import UIKit

public extension UIViewController {
    /// Checks for a forced update at the specified level (major, minor, patch).
    /// If needed, presents an alert prompting the user to update.
    ///
    /// - Parameter level: The update level threshold (default = .minor).
    func showForceUpdateDialogIfNeeded(level: UpdateLevel = .minor) {
        Task { @MainActor in
            let needsUpdate = await Hawk.checkIsNeedForceUpdate(level: level)
            if needsUpdate {
                let alertController = UIAlertController(
                    title: String(localized: "Dialog.Title", bundle: .module),
                    message: String(localized: "Dialog.Message", bundle: .module),
                    preferredStyle: .alert
                )

                let updateAction = UIAlertAction(title: String(localized: "Dialog.ButtonTitle", bundle: .module), style: .default) { _ in
                    if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                       let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
                        UIApplication.shared.open(url)
                    }
                }

                alertController.addAction(updateAction)
                present(alertController, animated: true)
            }
        }
    }

    /// Checks for a forced update at the specified level (major, minor, patch).
    /// If needed, presents a custom dialog prompting the user to update.
    ///
    /// - Parameters:
    ///   - level: The update level threshold (default = .minor).
    ///   - dialog: The custom dialog to display when an update is needed.
    func showForceUpdateDialogIfNeeded<Dialog: ForceUpdateViewController>(
        level: UpdateLevel = .minor,
        dialog: Dialog
    ) {
        Task { @MainActor in
            let needsUpdate = await Hawk.checkIsNeedForceUpdate(level: level)
            if needsUpdate {
                let viewController = dialog.makeForceUpdateDialog()
                present(viewController, animated: true)
            }
        }
    }
}
