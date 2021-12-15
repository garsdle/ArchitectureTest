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
            WithViewModel(AircraftViewModel(flightController: coordinator.flightController)) { viewModel in
                AircraftView(ticketCount: viewModel.ticketCount, onSwitchToFlight: coordinator.switchToFlight)
            }
//            AircraftContainerView(onSwitchToFlight: coordinator.switchToFlight,
//                                  flightController: coordinator.flightController)
            
//            WithAnyPublisher(coordinator.flightController.ticketCount(), initialValue: 0) { value in
//                AircraftView(ticketCount: value,
//                             onSwitchToFlight: coordinator.switchToFlight)
//            }
        }
    }
}

class AircraftViewModel: ObservableObject {
    @Published var ticketCount: Int = 0

    init(flightController: FlightController) {
        flightController.ticketCount()
            .assign(to: &$ticketCount)
    }
}

//struct AircraftContainerView: View {
//    @State var ticketCount: Int = 0
//    let onSwitchToFlight: () -> Void
//    let flightController: FlightController
//    
//    var body: some View {
//        AircraftView(ticketCount: ticketCount, onSwitchToFlight: onSwitchToFlight)
//            .onReceive(flightController.ticketCount()) { ticketCount in
//                self.ticketCount = ticketCount
//            }
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
