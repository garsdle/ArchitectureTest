import SwiftUI
import Combine

class MainCoordinator: ObservableObject {
    @Published var screen: Screen!
    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
        presentFlight()
    }

    func presentAircraft() {
        screen = .aircraft(.init(switchToFlight: presentFlight, environment: environment))
    }

    func presentFlight() {
        screen = .flight(.init(switchToAircraft: presentAircraft, environment: environment))
    }

    enum Screen {
        case flight(FlightCoordinator)
        case aircraft(AircraftCoordinator)
    }
}

struct MainCoordinatorView: View {
    @StateObject var coordinator: MainCoordinator

    var body: some View {
        switch coordinator.screen! {
        case .flight(let flightCoordinator):
            FlightCoordinatorView(coordinator: flightCoordinator)
        case .aircraft(let aircraftCoordinator):
            AircraftCoordinatorView(coordinator: aircraftCoordinator)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView(coordinator: MainCoordinator(environment: .mock))
    }
}
