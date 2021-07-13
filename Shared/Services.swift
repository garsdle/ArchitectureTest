import Foundation
import Combine

class FlightService: ObservableObject {
    @Published var flights: [Flight.ID: Flight] = [:] {
        didSet {
            sortedFlights = flightService.flights.values.sorted(by: { $0.name < $1.name })
        }
    }
    @Published var selectedFlightId: Flight.ID?

    var sortedFlights: [Flight] = []

    var cancelBag = Set<AnyCancellable>()

    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [:])
            .assign(to: &$flights)
    }

    func delete(flightId: Flight.ID) {
        current.api.deleteFlight(flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
    }

    func delete(_ indexSet: IndexSet)  {
        indexSet
            .map { sortedFlights[$0].id }
            .forEach(delete(flightId:))
    }
}

class TicketService: ObservableObject {
    @Published var tickets: [Ticket.ID: Ticket] = [:]

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

struct NestingFlight: Identifiable, Equatable {
    let id: UUID
    var name: String { id.uuidString }
    var tickets: [Ticket]

    static var mock: NestingFlight {
        NestingFlight(id: .init(), tickets: [.mock, .mock])
    }
}

struct Flight: Identifiable, Equatable {
    let id: UUID
    var name: String { id.uuidString }

    static var mock: Flight {
        Flight(id: .init())
    }
}

struct Ticket: Identifiable, Equatable {
    let id: UUID
    let flightId: Flight.ID
    var name: String

    init(id: UUID, flightId: UUID) {
        self.id = id
        self.flightId = flightId
        self.name = id.uuidString
    }

    static var mock: Ticket {
        Ticket(id: .init(), flightId: .init())
    }
}
