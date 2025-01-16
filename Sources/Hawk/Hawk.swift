// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct Hawk {
    public func checkIsNeedForceUpdate(level: UpdateLevel) async -> Bool {
        do {
            guard let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                  let url = URL(string: "https://itunes.apple.com/jp/lookup?id=\(appId)") else {
                return false
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = jsonData["results"] as? [[String: Any]],
                  let firstResult = results.first,
                  let storeVersionString = firstResult["version"] as? String else {
                return false
            }

            guard let appVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                return false
            }

            let storeVersion = Version(storeVersionString)
            let localVersion = Version(appVersionString)

            return needsForceUpdate(local: localVersion, store: storeVersion, level: level)

        } catch {
            return false
        }
    }

    private func needsForceUpdate(
        local localVersion: Version,
        store storeVersion: Version,
        level: UpdateLevel
    ) -> Bool {
        switch level {
        case .major:
            return storeVersion.major > localVersion.major

        case .minor:
            if storeVersion.major > localVersion.major { return true }
            if storeVersion.major == localVersion.major &&
                storeVersion.minor > localVersion.minor {
                return true
            }
            return false

        case .patch:
            return storeVersion > localVersion
        }
    }
}
