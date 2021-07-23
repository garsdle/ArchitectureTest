import SwiftUI

let appStore = AppStore(initialState: .init())

@main
struct ArchitectureTestApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(\.appStore, AppStore(initialState: .init()))
        }
    }
}
