import SwiftUI
import Hawk

struct ContentView: View {
    @State private var shouldMove = false

    var body: some View {
        NavigationStack {
            Button {
                shouldMove.toggle()
            } label: {
                Text("Show force update dialog if needed")
                    .foregroundStyle(.black)
            }
            .padding()
            .background(.blue, in: RoundedRectangle(cornerRadius: 30))
            .navigationDestination(isPresented: $shouldMove) {
                HawkView()
            }
        }
    }
}

struct HawkView: View {
    var body: some View {
        EmptyView()
            .showForceUpdateDialogIfNeeded()
    }
}

#Preview {
    ContentView()
}
