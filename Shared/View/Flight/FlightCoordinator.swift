import SwiftUI
import Combine

class FlightCoordinator: ObservableObject {
    @Published var flightViewModel: FlightViewModel?
    @Published var ticketViewModel: TicketViewModel?
    var loadingViewModel: LoadingViewModel!
    let switchToAircraft: () -> Void

    private let flightController: FlightController
    
    init(switchToAircraft: @escaping () -> Void, flightController: FlightController) {
        self.switchToAircraft = switchToAircraft
        self.flightController = flightController
        
        self.loadingViewModel = LoadingViewModel(onFlightLoaded: open(flight:),
                                                 flightController: flightController)
        
        if let flight = flightController.flight {
            open(flight: flight)
        }
    }
    
    func open(flight: NestingFlight) {
        self.flightViewModel = FlightViewModel(flight: flight, flightController: flightController)
    }

    func open(ticket: Ticket) {
        self.ticketViewModel = TicketViewModel(ticket: ticket,
                                              flightController: flightController)
    }
}

struct FlightCoordinatorView: View {
    @ObservedObject var coordinator: FlightCoordinator

    var body: some View  {
        NavigationView {
            if let flightViewModel = coordinator.flightViewModel {
                WithViewModel(flightViewModel) { vm in
                    FlightView(flightName: vm.flightName,
                               tickets: vm.tickets,
                               onSelectTicket: coordinator.open(ticket:),
                               onDelete: flightViewModel.delete,
                               onAddTicket: flightViewModel.addTicket,
                               onSwitchToAircraft: coordinator.switchToAircraft)
                }
                .navigation(item: $coordinator.ticketViewModel) { $ticketViewModel in
                    WithViewModel(ticketViewModel) { viewModel in
                        TicketView(name: $ticketViewModel.name)
                    }
                }
            } else {
                WithViewModel(coordinator.loadingViewModel) { viewModel in
                    ProgressView()
                }
            }
        }
    }
}

class LoadingViewModel: ObservableObject {
    let onFlightLoaded: (NestingFlight) -> Void

    private var cancellables = Set<AnyCancellable>()

    init(onFlightLoaded: @escaping (NestingFlight) -> Void, flightController: FlightController) {
        self.onFlightLoaded = onFlightLoaded
        
        flightController.$flight
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
    @Published private(set) var tickets: [Ticket] = []

    private let flightId: Flight.ID
    private let flightController: FlightController

    init(flight: NestingFlight, flightController: FlightController) {
        self.flightName = flight.name
        self.flightId = flight.id
        self.flightController = flightController

        flightController.$flight
            .compactMap(\.?.name)
            .assign(to: &$flightName)

        flightController.ticketsByName()
            .assign(to: &$tickets)
    }

    func delete(_ ticket: Ticket) {
        flightController.delete(ticket.id)
    }

    func addTicket() {
        flightController.addTicket(flightId: flightId)
    }
}

class TicketViewModel: ObservableObject {
    @Published var name: String

    private let ticketId: Ticket.ID
    private let flightController: FlightController
    private var cancellables = Set<AnyCancellable>()

    init(ticket: Ticket, flightController: FlightController) {
        self.name = ticket.name
        self.ticketId = ticket.id
        self.flightController = flightController

        flightController.publisher(ticketId: ticket.id)
            .removeDuplicates()
            .compactMap { $0?.name }
            .assign(to: &$name)

        $name
            .removeDuplicates()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: update(name:))
            .store(in: &cancellables)
    }

    func update(name: String) {
        flightController.update(name: name, ticketId: ticketId)
    }
}
