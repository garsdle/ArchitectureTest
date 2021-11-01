import Foundation
import Combine
import Difference

struct API {
    let getFlight: () -> AnyPublisher<NestingFlight?, APIError>
    let getTickets: () -> AnyPublisher<[Ticket.ID: Ticket], APIError>
    let addTicket: (Ticket) -> AnyPublisher<Void, APIError>
    let updateTicket: (Ticket) -> AnyPublisher<Void, APIError>
    let deleteTicket: (Ticket.ID) -> AnyPublisher<Void, APIError>
}

extension API {
    static var mock: API {
        API(
            getFlight: {
                mockPublisher(mockServer.getFlight())
            },
            getTickets: {
                mockPublisher(mockServer.getTickets())
            },
            addTicket: { ticket in
                mockPublisher(mockServer.add(ticket: ticket))
            },
            updateTicket: { ticket in
                mockPublisher(mockServer.update(ticket: ticket))
            },
            deleteTicket: { ticketId in
                mockPublisher(mockServer.delete(ticketId: ticketId))
            }
        )
    }

    static func mockPublisher<T>(_ value: T) -> AnyPublisher<T, APIError> {
        Just(value)
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}

enum APIError: Error { }


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

class MockServer {
    let flightId = UUID()

    var tickets = [Ticket.ID: Ticket]() {
        didSet {
//            print(dumpDiff(oldValue, tickets))
        }
    }

    init() {
        for _ in 0..<8 {
            let ticket = Ticket(id: .init(), flightId: flightId)
            tickets[ticket.id] = ticket
        }
    }

    func getFlight() -> NestingFlight? {
        NestingFlight(id: flightId, tickets: Array(tickets.values))
    }

    func getTickets() -> [Ticket.ID: Ticket] {
        tickets
    }

    func add(ticket: Ticket) {
        tickets[ticket.id] = ticket
//        print("􀪹 Added ticket")
    }

    func update(ticket: Ticket) {
        tickets[ticket.id] = ticket
//        print("􀪹 Updated ticket")
    }

    func delete(ticketId: Ticket.ID) {
        tickets.removeValue(forKey: ticketId)
    }
}

let mockServer = MockServer()
