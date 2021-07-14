import Foundation
import Combine

class TicketService: ObservableObject {
    @Published private(set) var tickets: [Ticket.ID: Ticket] = [:]

    var cancelBag = Set<AnyCancellable>()

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