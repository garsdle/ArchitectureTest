import SwiftUI

@main
struct ArchitectureTestApp: App {
    @StateObject var coordinator = MainCoordinator(environment: .mock)

    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(coordinator: coordinator)
        }
    }
}
