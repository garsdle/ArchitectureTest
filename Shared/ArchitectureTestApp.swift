import SwiftUI

let appStore = AppStore(initialState: .init())

@main
struct ArchitectureTestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
