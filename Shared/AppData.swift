import Foundation
import SwiftUI

class AppData: ObservableObject {
    @Published var flights: [NestingFlight] = []

    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [])
            .assign(to: &$flights)
    }

    func update(ticketName: String, flightId: NestingFlight.ID, ticketId: Ticket.ID) {
        guard let flightIndex = flights.firstIndex(where: { $0.id == flightId }) else { return }
        guard let ticketIndex = flights[flightIndex].tickets.firstIndex(where: { $0.id == ticketId }) else { return }
        flights[flightIndex].tickets[ticketIndex].name = ticketName
    }
}

struct NestingFlight: Identifiable {
    let id: UUID
    var name: String { id.uuidString }
    var tickets: [Ticket]
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
