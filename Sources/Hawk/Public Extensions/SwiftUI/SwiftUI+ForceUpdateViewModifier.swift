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
 * A view modifier that checks if a force update is required and displays a custom dialog
 * if needed.
 */
struct CustomForceUpdateViewModifier<Dialog: ForceUpdateDialog>: ViewModifier {
    /**
     * Indicates whether the update dialog should be shown. Defaults to `false`.
     */
    @State private var showUpdateDialog = false

    let blurColor: Color

    /**
     * Determines the level of update to check (major, minor, or patch).
     */
    let updateLevel: UpdateLevel

    /**
     * The custom dialog to display when an update is needed.
     */
    let dialog: Dialog

    /**
     * Constructs the body of the view modifier, initiating the force update check
     * and displaying a custom dialog if needed.
     *
     * - Parameter content: The content view that the modifier is applied to.
     * - Returns: A modified view that performs the force update check.
     */
    func body(content: Content) -> some View {
        ZStack {
            content
                .task {
                    let needUpdate = await Hawk.checkIsNeedForceUpdate(level: updateLevel)
                    if needUpdate {
                        showUpdateDialog = true
                    }
                }

            if showUpdateDialog {
                ZStack {
                    blurColor
                        .ignoresSafeArea(edges: .all)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: .all)
                .allowsHitTesting(false)

                dialog.makeDialogView()
                    .zIndex(1)
            }
        }
    }
}


/**
 * Provides a convenient way to apply the `ForceUpdateViewModifier` on any view.
 */
public extension View {
    /**
     * Checks if the app needs to be force-updated at the specified update level.
     * Displays the standard alert dialog if an update is needed.
     *
     * - Parameter level: The threshold for determining a required update (default is `.minor`).
     * - Returns: A view modified to check for a force update.
     */
    func showForceUpdateDialogIfNeeded(level: UpdateLevel = .minor) -> some View {
        modifier(ForceUpdateViewModifier(updateLevel: level))
    }

    /**
     * Checks if the app needs to be force-updated at the specified update level.
     * Displays a custom dialog if an update is needed.
     *
     * - Parameters:
     *   - level: The threshold for determining a required update (default is `.minor`).
     *   - blurColor: The background color to use for the overlay (default is clear).
     *   - dialog: The custom dialog to display when an update is needed.
     * - Returns: A view modified to check for a force update with a custom dialog.
     */
    func showForceUpdateDialogIfNeeded<Dialog: ForceUpdateDialog>(
        level: UpdateLevel = .minor,
        blurColor: Color = .clear,
        dialog: Dialog
    ) -> some View {
        modifier(CustomForceUpdateViewModifier(blurColor: blurColor, updateLevel: level, dialog: dialog))
    }
}
