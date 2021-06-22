import Foundation
import Combine
import Difference

struct API {
    let getFlights: () -> AnyPublisher<[NestingFlight], APIError>
    let deleteFlight: (Flight.ID) -> AnyPublisher<Void, APIError>
    let addTicket: (Ticket, Flight.ID) -> AnyPublisher<Void, APIError>
    let updateTicket: (Ticket) -> AnyPublisher<Void, APIError>
}

extension API {
    static var mock: API {
        API(getFlights: {
                mockPublisher(mockServer.getFlights())
            },
            deleteFlight: { flightId in
                mockPublisher(mockServer.delete(flightId: flightId))
            },
            addTicket: { ticket, flightId in
            mockPublisher(mockServer.add(ticket: ticket))
            },
            updateTicket: { ticket in
            mockPublisher(mockServer.update(ticket: ticket))
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
    var flights = [Flight.ID: Flight]() {
        didSet {
            print(dumpDiff(oldValue, flights))
        }
    }
    var tickets = [Ticket.ID: Ticket]() {
        didSet {
            print(dumpDiff(oldValue, tickets))
        }
    }

    init() {
        for _ in 0..<2 {
            let flight = Flight(id: .init())
            flights[flight.id] = flight

            for _ in 0..<2 {
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

    func delete(flightId: Flight.ID) {
        tickets = tickets.filter { ticketPair in
            ticketPair.value.flightId != flightId
        }
        flights.removeValue(forKey: flightId)
        print("􀪹 Deleted flight")
    }

    func add(ticket: Ticket) {
        tickets[ticket.id] = ticket
        print("􀪹 Added ticket")
    }

    func update(ticket: Ticket) {
        tickets[ticket.id] = ticket
        print("􀪹 Updated ticket")
    }
}

let mockServer = MockServer()
