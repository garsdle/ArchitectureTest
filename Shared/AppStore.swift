import Foundation
import Combine

struct AppState: Equatable {
    var flights: [Flight.ID: Flight] = [:] {
        didSet {
            sortedFlights = flights.values.sorted { $0.name < $1.name }
        }
    }
     var sortedFlights: [Flight] = []
     var selectedFlightId: Flight.ID?

     var tickets: [Ticket.ID: Ticket] = [:]
}

@dynamicMemberLookup
class AppStore: Store<AppState> {
    @Published private(set) var appState = AppState()

    private var cancelBag = Set<AnyCancellable>()

    subscript<T>(dynamicMember keyPath: KeyPath<AppState, T>) -> T {
        appState[keyPath: keyPath]
    }
}

extension AppStore {
    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [:])
            .sink { [weak self] flights in
                self?.appState.flights = flights
            }
            .store(in: &cancelBag)
    }

    func delete(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let flight = appState.sortedFlights[index]
        appState.flights.removeValue(forKey: flight.id)

        //This is not optimal but can be looked at later..
        appState.tickets = appState.tickets.filter { $0.value.flightId != flight.id}
        current.api.deleteFlight(flight.id)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
    }
}

extension AppStore {
    var ticketCount: Int {
        appState.tickets.count
    }

    func tickets(for flightId: Flight.ID) -> [Ticket] {
        appState.tickets.values
            .filter { $0.flightId == flightId }
            .sorted { $0.name < $1.name }
    }

    func addTicket(flightId: Flight.ID) {
        let newTicket = Ticket(id: UUID(), flightId: flightId)

        current.api.addTicket(newTicket, flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancelBag)

        appState.tickets[newTicket.id] = newTicket
    }

    func update(ticket: Ticket) {
        current.api.updateTicket(ticket)
            .sink { completion in
                // TODO: Do something with error!
            } receiveValue: {
                // TODO: Should it only update locally on success?
            }
            .store(in: &cancelBag)

        // TODO: And what about persisting

        appState.tickets[ticket.id] = ticket
    }

    func loadTickets() {
        current.api.getTickets()
            .replaceError(with: [:])
            .sink { [weak self] tickets in
                self?.appState.tickets = tickets
            }
            .store(in: &cancelBag)
    }
}
