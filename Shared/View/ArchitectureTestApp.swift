import SwiftUI

@main
struct ArchitectureTestApp: App {
    @StateObject var coordinator = MainCoordinator()

    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(coordinator: coordinator)
        }
    }
}
