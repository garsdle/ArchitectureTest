import SwiftUI
import Combine

class MainCoordinator: ObservableObject {
    @Published var screen: Screen!

    let flightController = FlightController(api: current.api, uuidGenerator: current.uuidGenerator)
    
    init() {
        presentFlight()
    }

    func presentAircraft() {
        screen = .aircraft(AircraftCoordinator(switchToFlight: presentFlight,
                                               flightController: flightController))
    }

    func presentFlight() {
        screen = .flight(FlightCoordinator(switchToAircraft: presentAircraft,
                                           flightController: flightController))
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
