import Foundation
import SwiftUI
import Combine

class AppData: ObservableObject {
    @Published private(set) var flights: [NestingFlight] = []

    var cancelBag = Set<AnyCancellable>()

    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [])
            .assign(to: &$flights)
    }

    func deleteFlight(at indexSet: IndexSet) {
        indexSet
            .map { flights[$0] }
            .map { current.api.deleteFlight($0.id) }
            .publisher
            .sink { _ in }
            .store(in: &cancelBag)

        flights.remove(atOffsets: indexSet)
    }

    func addTicket(flightId: Flight.ID) {
        guard let flightIndex = flights.firstIndex(where: { $0.id == flightId }) else { return }
        let newTicket = Ticket(id: UUID(), flightId: flightId)

        current.api.addTicket(newTicket, flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancelBag)

        flights[flightIndex].tickets.append(newTicket)
    }

    func update(ticket: Ticket, flightId: NestingFlight.ID) {
        guard let flightIndex = flights.firstIndex(where: { $0.id == flightId }) else { return }
        guard let ticketIndex = flights[flightIndex].tickets.firstIndex(where: { $0.id == ticket.id }) else { return }

        current.api.updateTicket(ticket)
            .sink { completion in
                // TODO: Do something with error!
            } receiveValue: {
                // TODO: Should it only update locally on success?
            }
            .store(in: &cancelBag)

        // TODO: And what about persisting

        flights[flightIndex].tickets[ticketIndex] = ticket
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
