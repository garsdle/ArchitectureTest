import SwiftUI
import Combine

class MainCoordinator: ObservableObject {
    @Published var screen: Screen!

    init() {
        presentFlight()
    }

    func presentAircraft() {
        screen = .aircraft(.init(switchToFlight: presentFlight))
    }

    func presentFlight() {
        screen = .flight(.init(switchToAircraft: presentAircraft))
    }
}

extension MainCoordinator {
    enum Screen {
        case flight(FlightCoordinator)
        case aircraft(AircraftCoordinator)
    }
}

struct MainCoordinatorView: View {
    @StateObject var coordinator = MainCoordinator()

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
        MainCoordinatorView(coordinator: .init())
    }
}
