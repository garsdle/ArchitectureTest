import SwiftUI

class AircraftCoordinator: ObservableObject {
    let aircraftViewModel = AircraftViewModel(flightService: current.flightService)
    let switchToFlight: () -> Void

    init(switchToFlight: @escaping () -> Void) {
        self.switchToFlight = switchToFlight
    }
}

struct AircraftCoordinatorView: View {
    @ObservedObject var coordinator: AircraftCoordinator

    var body: some View {
        NavigationView {
            WithViewModel(coordinator.aircraftViewModel) { viewModel in
                AircraftView(ticketCount: viewModel.ticketCount,
                             onSwitchToFlight: coordinator.switchToFlight)
            }
        }
    }
}

class AircraftViewModel: ObservableObject {
    @Published var ticketCount: Int = 90

    init(flightService: FlightService) {
        flightService.guestCount()
            .assign(to: &$ticketCount)
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
