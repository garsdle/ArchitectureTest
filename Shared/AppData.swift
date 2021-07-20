import Foundation
import Combine

class AppData: ObservableObject {
    @Published private(set) var flights: [Flight.ID: Flight] = [:] {
        didSet {
            sortedFlights = flights.values.sorted(by: { $0.name < $1.name })
        }
    }
    @Published private(set)var sortedFlights: [Flight] = []
    @Published private(set) var selectedFlightId: Flight.ID?
    
    @Published private(set) var tickets: [Ticket.ID: Ticket] = [:]

    private var cancelBag = Set<AnyCancellable>()
}

extension AppData {
    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [:])
            .assign(to: &$flights)
    }

    func delete(_ indexSet: IndexSet) {
        indexSet
            .map { sortedFlights[$0].id }
            .map(current.api.deleteFlight)
            .forEach {
                // FIXME: This needs to be done better
                $0.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .store(in: &cancelBag)
            }
    }
}

extension AppData {
    var ticketCount: Int {
        tickets.count
    }

    func tickets(for flightId: Flight.ID) -> [Ticket] {
        tickets.values
            .filter { $0.flightId == flightId }
            .sorted { $0.name < $1.name }
    }

    func addTicket(flightId: Flight.ID) {
        let newTicket = Ticket(id: UUID(), flightId: flightId)

        current.api.addTicket(newTicket, flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancelBag)

        tickets[newTicket.id] = newTicket
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

        tickets[ticket.id] = ticket
    }

    func loadTickets() {
        current.api.getTickets()
            .replaceError(with: [:])
            .assign(to: &$tickets)
    }
}
