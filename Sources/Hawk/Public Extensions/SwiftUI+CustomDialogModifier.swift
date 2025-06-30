//
//  SwiftUI+CustomDialogModifier.swift
//  Hawk
//
//  Created by reeen on 2025/06/30.
//

import SwiftUI

private struct CustomDialogModifier: ViewModifier {
    @State private var showUpdateAlert = false
    let updateLevel: UpdateLevel
    let customDialog: AnyView

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
    /// Checks if the app needs to be force-updated and displays a custom dialog.
    ///
    /// - Parameters:
    ///   - level: The threshold for determining a required update (default is `.minor`).
    ///   - content: The custom view to display when an update is needed.
    /// - Returns: A view modified to check for a force update with custom dialog.
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
