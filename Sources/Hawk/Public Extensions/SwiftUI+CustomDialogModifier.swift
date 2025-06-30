//
//  SwiftUI+CustomDialogModifier.swift
//  Hawk
//
//  Created by reeen on 2025/06/30.
//

import SwiftUI

/// A view modifier that checks if a force update is required and displays a custom dialog
/// when an update is needed. This modifier allows you to create your own custom update dialog
/// instead of using the default alert.
private struct CustomDialogModifier: ViewModifier {
    /**
     * Indicates whether the custom update dialog should be shown. Defaults to `false`.
     */
    @State private var showUpdateAlert = false

    /**
     * Determines the level of update to check (major, minor, or patch).
     */
    let updateLevel: UpdateLevel

    /**
     * The custom view to display when an update is needed.
     */
    let customDialog: AnyView

    /**
     * Constructs the body of the view modifier, initiating the force update check
     * and displaying the custom dialog if needed.
     *
     * - Parameter content: The content view that the modifier is applied to.
     * - Returns: A modified view that performs the force update check with custom dialog.
     */
    func body(content: Content) -> some View {
        ZStack {
            if showUpdateAlert {
                customDialog
            }

            content
                .task {
                    let needUpdate = await Hawk.checkIsNeedForceUpdate(level: updateLevel)
                    if needUpdate {
                        showUpdateAlert = true
                    }
                }
        }
    }
}

extension View {
    /**
     * Checks if the app needs to be force-updated and displays a custom dialog when an update is required.
     * This method allows you to create your own custom update dialog instead of using the default alert.
     *
     * - Parameters:
     *   - level: The threshold for determining a required update (default is `.minor`).
     *   - content: A closure that returns the custom view to display when an update is needed.
     *             You can call `Hawk.openAppStore()` directly within this closure to open the App Store.
     * - Returns: A view modified to check for a force update with custom dialog.
     *
     * ## Example Usage
     * ```swift
     * .showForceUpdateDialogIfNeeded(level: .minor) {
     *     VStack {
     *         Text("新しいバージョンが利用可能です")
     *         Button("App Storeを開く") {
     *             Hawk.openAppStore()
     *         }
     *     }
     *     .padding()
     *     .background(Color.white)
     *     .cornerRadius(10)
     * }
     * ```
     */
    public func showForceUpdateDialogIfNeeded<Content: View>(
        level: UpdateLevel = .minor,
        @ViewBuilder content: () -> Content
    ) -> some View {
        modifier(
            CustomDialogModifier(
                updateLevel: level,
                customDialog: AnyView(content())
            ))
    }
}
