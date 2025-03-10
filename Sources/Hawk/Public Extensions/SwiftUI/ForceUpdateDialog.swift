import SwiftUI

/**
 * A protocol that defines the requirements for a custom force update dialog.
 * Implement this protocol to create your own custom update dialog.
 */
@MainActor
public protocol ForceUpdateDialog {
    /// The associated type that represents the view to be presented
    associatedtype DialogView: View

    /**
     * Creates and returns a view that represents the force update dialog.
     *
     * - Returns: A view that will be presented as the force update dialog.
     */
    @ViewBuilder func makeDialogView() -> DialogView

    /**
     * Opens the App Store to update the app.
     */
    func openAppStore() async
}

/**
 * Default implementation for the ForceUpdateDialog protocol.
 */
extension ForceUpdateDialog {
    /**
     * Default implementation to open the App Store.
     */
    public func openAppStore() {
        if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
           let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
            UIApplication.shared.open(url)
        }
    }
}
