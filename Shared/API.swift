import Foundation
import Combine

struct API {
    let getFlights: () -> AnyPublisher<[NestingFlight], APIError>
    let updateTicket: (Ticket) -> AnyPublisher<Void, APIError>
}

extension API {
    static var mock: API {
        API(getFlights: {
                mockPublisher(mockServer.getFlights())
            },
            updateTicket: { ticket in
                mockPublisher(())
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

class MockServer {
    var flights = [Flight.ID: Flight]()
    var tickets = [Ticket.ID: Ticket]()

    init() {
        for _ in 0..<10 {
            let flight = Flight(id: .init())
            flights[flight.id] = flight

            for _ in 0..<10 {
                let ticket = Ticket(id: .init(), flightId: flight.id)
                tickets[ticket.id] = ticket
            }
        }
    }

    func getFlights() -> [NestingFlight] {
        var nestingFlights = [NestingFlight.ID: NestingFlight]()
        flights.forEach { id, flight in
            nestingFlights[id] = NestingFlight(id: id, tickets: [])
        }

        tickets.forEach { id, ticket in
            nestingFlights[ticket.flightId]?.tickets.append(ticket)
        }

        return Array(nestingFlights.values)
    }

    func update(ticketId: Ticket.ID, name: String) {
        tickets[ticketId]?.name = name
    }

    func add(ticket: Ticket) {
        tickets[ticket.id] = ticket
    }
}

let mockServer = MockServer()
