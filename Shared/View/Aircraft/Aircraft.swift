import SwiftUI

class AircraftCoordinator: ObservableObject {
    let switchToFlight: () -> Void
    let flightController: FlightController
    
    init(switchToFlight: @escaping () -> Void, flightController: FlightController) {
        self.flightController = flightController
        self.switchToFlight = switchToFlight
    }
}

struct AircraftCoordinatorView: View {
    @ObservedObject var coordinator: AircraftCoordinator

    var body: some View {
        NavigationView {
            WithAnyPublisher(coordinator.flightController.guestCount(), initialValue: 0) { value in
                AircraftView(ticketCount: value,
                             onSwitchToFlight: coordinator.switchToFlight)
            }
        }
    }
}

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
