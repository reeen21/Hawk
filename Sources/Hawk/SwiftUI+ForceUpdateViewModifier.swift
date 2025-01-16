import SwiftUI

/**
 * A view modifier that checks if a force update is required based on a specified
 * `updateLevel`. When the app version is outdated, an alert prompts the user to update.
 */
struct ForceUpdateViewModifier: ViewModifier {

    /**
     * Indicates whether the update alert should be shown. Defaults to `false`.
     */
    @State private var showUpdateAlert = false

    /**
     * Determines the level of update to check (major, minor, or patch).
     */
    let updateLevel: UpdateLevel

    /**
     * Constructs the body of the view modifier, initiating the force update check
     * and displaying an alert if needed.
     *
     * - Parameter content: The content view that the modifier is applied to.
     * - Returns: A modified view that performs the force update check.
     */
    func body(content: Content) -> some View {
        content
            .task {
                let needUpdate = await Hawk.checkIsNeedForceUpdate(level: updateLevel)
                if needUpdate {
                    showUpdateAlert = true
                }
            }
            .alert(String(localized: "Dialog.Title", bundle: .module), isPresented: $showUpdateAlert) {
                Button(String(localized: "Dialog.ButtonTitle", bundle: .module)) {
                    if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                       let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text(String(localized: "Dialog.Message", bundle: .module))
            }
    }
}

/**
 * Provides a convenient way to apply the `ForceUpdateViewModifier` on any view.
 */
public extension View {
    /**
     * Checks if the app needs to be force-updated at the specified update level.
     *
     * - Parameter level: The threshold for determining a required update (default is `.minor`).
     * - Returns: A view modified to check for a force update.
     */
    func showForceUpdateDialogIfNeeded(level: UpdateLevel = .minor) -> some View {
        modifier(ForceUpdateViewModifier(updateLevel: level))
    }
}
