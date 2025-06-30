import UIKit

extension UIViewController {

    /// Checks for a forced update at the specified level (major, minor, patch).
    /// If needed, presents an alert prompting the user to update.
    ///
    /// - Parameter level: The update level threshold (default = .minor).
    public func showForceUpdateDialogIfNeeded(level: UpdateLevel = .minor) {
        // Run an asynchronous task on the main actor so alert presentation
        // happens on the main thread.
        Task { @MainActor in
            let needsUpdate = await Hawk.checkIsNeedForceUpdate(level: level)
            if needsUpdate {
                presentUpdateAlert()
            }
        }
    }

    public func showForceUpdateDialogIfNeeded(
        level: UpdateLevel = .minor,
        customDialog: @escaping () -> UIView
    ) {
        Task { @MainActor in
            let needUpdate = await Hawk.checkIsNeedForceUpdate(level: level)
            if needUpdate {
                let dialogView = customDialog()
                presentCustomDialog(dialogView)
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

        let updateAction = UIAlertAction(
            title: String(localized: "Dialog.ButtonTitle", bundle: .module), style: .default
        ) { _ in
            // Replace with your real App Store link or logic
            if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)")
            {
                UIApplication.shared.open(url)
            }
        }

        alertController.addAction(updateAction)
        present(alertController, animated: true)
    }

    private func presentCustomDialog(_ dialogView: UIView) {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(dialogView)
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dialogView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            dialogView.leadingAnchor.constraint(
                greaterThanOrEqualTo: overlayView.leadingAnchor, constant: 20),
            dialogView.trailingAnchor.constraint(
                lessThanOrEqualTo: overlayView.trailingAnchor, constant: -20),
        ])
    }
}
