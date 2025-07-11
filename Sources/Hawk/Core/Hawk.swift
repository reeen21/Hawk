import SwiftUI

/// A service that manages version checks against the App Store, determining whether
/// a force update is necessary based on a given update level.
public enum Hawk {
    /**
     * Checks if a force update is needed by comparing the local app version to the
     * App Store version or the versions provided explicitly.
     *
     * - Parameters:
     *   - level: The minimum update level (major, minor, or patch).
     *   - localVersion: An optional local version for testing or overriding. If `nil`,
     *                   the app's `CFBundleShortVersionString` will be used.
     *   - storeVersion: An optional store version for testing or overriding. If `nil`,
     *                   it will be fetched from the App Store API.
     * - Returns: `true` if a force update is needed, otherwise `false`.
     */
    static func checkIsNeedForceUpdate(
        level: UpdateLevel,
        localVersion: String? = nil,
        storeVersion: String? = nil
    ) async -> Bool {
        do {
            if let localVersion, let storeVersion {
                return needsForceUpdate(local: localVersion, store: storeVersion, level: level)
            }

            guard let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                let url = URL(string: "https://itunes.apple.com/jp/lookup?id=\(appId)")
            else {
                return false
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = jsonData["results"] as? [[String: Any]],
                let firstResult = results.first,
                let storeVersionString = firstResult["version"] as? String
            else {
                return false
            }

            guard
                let appVersionString = Bundle.main.object(
                    forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else {
                return false
            }

            return needsForceUpdate(
                local: appVersionString, store: storeVersionString, level: level)
        } catch {
            return false
        }
    }

    /**
     * Compares the local and store versions based on the specified update level.
     *
     * - Parameters:
     *   - localVersion: The local app version.
     *   - storeVersion: The app version in the App Store.
     *   - level: The threshold for forcing an update (major, minor, or patch).
     * - Returns: `true` if the store version is high enough above the local version
     *            to warrant an update, otherwise `false`.
     */
    private static func needsForceUpdate(
        local localVersionString: String,
        store storeVersionString: String,
        level: UpdateLevel
    ) -> Bool {
        let storeVersion = Version(storeVersionString)
        let localVersion = Version(localVersionString)
        switch level {
        case .major:
            return storeVersion.major > localVersion.major

        case .minor:
            if storeVersion.major != localVersion.major {
                return storeVersion.major > localVersion.major
            }
            return storeVersion.minor > localVersion.minor

        case .patch:
            if storeVersion.major != localVersion.major {
                return storeVersion.major > localVersion.major
            }
            if storeVersion.minor != localVersion.minor {
                return storeVersion.minor > localVersion.minor
            }
            return storeVersion.patch > localVersion.patch
        }
    }

    /**
     * Opens the App Store page for the current app.
     * This method uses the AppStoreID from the app's Info.plist to construct the App Store URL.
     *
     * ## Usage
     * This method can be called directly from custom dialogs or anywhere in your app
     * where you need to redirect users to the App Store.
     *
     * ```swift
     * Button("Open App Store") {
     *     Hawk.openAppStore()
     * }
     * ```
     */
    @MainActor
    public static func openAppStore() {
        if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
            let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)")
        {
            UIApplication.shared.open(url)
        }
    }
}
