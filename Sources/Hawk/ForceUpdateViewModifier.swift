import SwiftUI

struct ForceUpdateViewModifier: ViewModifier {
    @State private var showUpdateAlert = false
    let updateLevel: UpdateLevel

    func body(content: Content) -> some View {
        content
            .task {
                let needUpdate = await Hawk().checkIsNeedForceUpdate(level: updateLevel)
                if needUpdate {
                    showUpdateAlert = true
                }
            }
            .alert("新しいバージョンが利用可能です", isPresented: $showUpdateAlert) {
                Button("今すぐアップデート") {
                    if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreID") as? String,
                       let url = URL(string: "https://apps.apple.com/jp/app/id\(appId)") {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("最新バージョンへアップデートをお願いします。")
            }
    }
}

public extension View {
    func forceUpdateCheck(level: UpdateLevel = .minor) -> some View {
        modifier(ForceUpdateViewModifier(updateLevel: level))
    }
}
