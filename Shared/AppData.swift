import Foundation
import SwiftUI

class AppData: ObservableObject {
    @Published private(set) var flights: [NestingFlight] = []

    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [])
            .assign(to: &$flights)
    }

    func update(ticket: Ticket, flightId: NestingFlight.ID) {
        guard let flightIndex = flights.firstIndex(where: { $0.id == flightId }) else { return }
        guard let ticketIndex = flights[flightIndex].tickets.firstIndex(where: { $0.id == ticket.id }) else { return }
        flights[flightIndex].tickets[ticketIndex] = ticket
    }

    func deleteFlight(at indexSet: IndexSet) {
        flights.remove(atOffsets: indexSet)
    }

    func addTicket(flightId: Flight.ID) {
        guard let flightIndex = flights.firstIndex(where: { $0.id == flightId }) else { return }
        let newTicket = Ticket(id: UUID(), flightId: flightId)
        flights[flightIndex].tickets.append(newTicket)
    }
}

struct NestingFlight: Identifiable {
    let id: UUID
    var name: String { id.uuidString }
    var tickets: [Ticket]

    static var mock: NestingFlight {
        NestingFlight(id: .init(), tickets: [.mock, .mock])
    }
}

struct Flight: Identifiable {
    let id: UUID
    var name: String { id.uuidString }

    static var mock: Flight {
        Flight(id: .init())
    }
}

struct Ticket: Identifiable {
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
