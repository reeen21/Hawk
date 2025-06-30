import UIKit

extension UIViewController {

    /**
     * Checks for a forced update at the specified level (major, minor, patch).
     * If needed, presents an alert prompting the user to update.
     *
     * - Parameter level: The update level threshold (default = .minor).
     */
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

    /**
     * Checks for a forced update and displays a custom dialog when an update is required.
     * This method allows you to create your own custom update dialog instead of using the default alert.
     *
     * - Parameters:
     *   - level: The update level threshold (default = .minor).
     *   - customDialog: A closure that returns the custom UIView to display when an update is needed.
     *                  You can call `Hawk.openAppStore()` directly within this closure to open the App Store.
     *
     * ## Example Usage
     * ```swift
     * showForceUpdateDialogIfNeeded(level: .minor) {
     *     let customView = UIView()
     *     let button = UIButton(type: .system)
     *     button.setTitle("App Storeを開く", for: .normal)
     *     button.addTarget(self, action: #selector(openAppStore), for: .touchUpInside)
     *     customView.addSubview(button)
     *     return customView
     * }
     *
     * @objc private func openAppStore() {
     *     Hawk.openAppStore()
     * }
     * ```
     */
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

    /**
     * Presents an alert telling the user a new version is available and prompting them to update.
     * This is the default alert implementation used when no custom dialog is provided.
     */
    private func presentUpdateAlert() {
        let alertController = UIAlertController(
            title: String(localized: "Dialog.Title", bundle: .module),
            message: String(localized: "Dialog.Message", bundle: .module),
            preferredStyle: .alert
        )

        let updateAction = UIAlertAction(
            title: String(localized: "Dialog.ButtonTitle", bundle: .module), style: .default
        ) { _ in
            if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)")
            {
                UIApplication.shared.open(url)
            }
        }

        alertController.addAction(updateAction)
        present(alertController, animated: true)
    }

    /**
     * Presents a custom dialog view as an overlay on the current view controller.
     * The dialog is centered and has a semi-transparent background.
     *
     * - Parameter dialogView: The custom UIView to display as a dialog.
     */
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
