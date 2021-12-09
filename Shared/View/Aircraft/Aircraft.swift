import SwiftUI

class AircraftCoordinator: ObservableObject {
    let switchToFlight: () -> Void
    let environment: AppEnvironment
    
    init(switchToFlight: @escaping () -> Void, environment: AppEnvironment) {
        self.environment = environment
        self.switchToFlight = switchToFlight
    }
}

struct AircraftCoordinatorView: View {
    @ObservedObject var coordinator: AircraftCoordinator

    var body: some View {
        NavigationView {
            WithAnyPublisher(coordinator.environment.flightController.guestCount(), initialValue: 0) { value in
                AircraftView(ticketCount: value,
                             onSwitchToFlight: coordinator.switchToFlight)
            }
        }
    }
}

//class AircraftViewModel: ObservableObject {
//    @Published var ticketCount: Int = 0
//
//    init(flightController: FlightController) {
//        flightController.guestCount()
//            .assign(to: &$ticketCount)
//    }
//}

struct AircraftView: View {
    let ticketCount: Int
    let onSwitchToFlight: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Occupied seats: \(ticketCount)")

            Button("Switch to Flight View", action: onSwitchToFlight)
        }
        .font(.title)
        .navigationTitle("Aircraft View")
    }
}
