import SwiftUI
import Combine

class FlightCoordinator: ObservableObject {
    @Published var flow = NFlow<Screen>()
    let switchToAircraft: () -> Void

    init(switchToAircraft: @escaping () -> Void) {
        self.switchToAircraft = switchToAircraft

        if let flight = current.flightService.flight {
            open(flight: flight)
        } else {
            self.openLoader()
        }
    }

    func openLoader() {
        flow.replaceNFlow(with: [
            .loading(.init(onFlightLoaded: open(flight:),
                                     flightService: current.flightService))
        ])
    }

    func open(flight: NestingFlight) {
        flow.replaceNFlow(with: [
            .flight(FlightViewModel(flightService: current.flightService,
                            flight: flight))
        ])
    }

    func open(ticket: Ticket) {
        flow.push(.detail(TicketViewModel(ticket: ticket)))
    }
}

extension FlightCoordinator {
    enum Screen {
        case loading(LoadingViewModel)
        case flight(FlightViewModel)
        case detail(TicketViewModel)
    }
}

struct FlightCoordinatorView: View {
    @ObservedObject var coordinator: FlightCoordinator

    var body: some View  {
        NavigationView {
            NStack($coordinator.flow) { screen in
                switch screen {
                case  .loading(let viewModel):
                    WithViewModel(viewModel) { viewModel in
                        ProgressView()
                    }
                case .flight(let viewModel):
                    WithViewModel(viewModel) { viewModel in
                        FlightScreen(flightName: viewModel.flightName,
                                     tickets: viewModel.tickets,
                                     onSelectTicket: coordinator.open(ticket:),
                                     onDelete: viewModel.delete,
                                     onAddTicket: viewModel.addTicket,
                                     onSwitchToAircraft: coordinator.switchToAircraft)
                    }
                case .detail(let viewModel):
                    WithViewModel(viewModel) { viewModel in
                        TicketView(name: viewModel.ticket.name)
                    }
                }
            }
        }
    }
}

class LoadingViewModel: ObservableObject {
    let onFlightLoaded: (NestingFlight) -> Void

    private var cancellables = Set<AnyCancellable>()

    init(onFlightLoaded: @escaping (NestingFlight) -> Void, flightService: FlightService) {
        self.onFlightLoaded = onFlightLoaded
        
        flightService.$flight
            .delay(for: 0.1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [unowned self] in
                self.onFlightLoaded($0)
            }
            .store(in: &cancellables)
    }
}

class FlightViewModel: ObservableObject {
    @Published private(set) var flightName: String
    @Published private(set) var tickets: [Ticket]

    private let flightId: Flight.ID
    private let flightService: FlightService

    init(flightService: FlightService, flight: NestingFlight) {
        self.flightService = flightService
        self.flightName = flight.name
        self.tickets = flight.tickets
        self.flightId = flight.id

        flightService.$flight
            .compactMap(\.?.name)
            .assign(to: &$flightName)
        flightService.$flight
            .compactMap(\.?.tickets)
            .assign(to: &$tickets)
    }

    func delete(_ ticket: Ticket) {
        flightService.delete(ticket.id)
    }

    func addTicket() {
        flightService.addTicket(flightId: flightId)
    }
}
