import Foundation
import Combine
import Difference

struct API {
    let getNestedFlights: () -> AnyPublisher<[NestingFlight], APIError>
    let getFlights: () -> AnyPublisher<[Flight.ID: Flight], APIError>
    let getTickets: () -> AnyPublisher<[Ticket.ID: Ticket], APIError>

    let deleteFlight: (Flight.ID) -> AnyPublisher<Void, APIError>
    let addTicket: (Ticket, Flight.ID) -> AnyPublisher<Void, APIError>
    let updateTicket: (Ticket) -> AnyPublisher<Void, APIError>
}

extension API {
    static var mock: API {
        API(getNestedFlights: {
                mockPublisher(mockServer.getNestedFlights())
            },
            getFlights: {
                mockPublisher(mockServer.getFlights())
            },
            getTickets: {
                mockPublisher(mockServer.getTickets())
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

class MockServer {
    var flights = [Flight.ID: Flight]() {
        didSet {
//            print(dumpDiff(oldValue, flights))
        }
    }
    var tickets = [Ticket.ID: Ticket]() {
        didSet {
//            print(dumpDiff(oldValue, tickets))
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

    func getFlights() -> [Flight.ID: Flight] {
        flights
    }

    func getTickets() -> [Ticket.ID: Ticket] {
        tickets
    }

    func getNestedFlights() -> [NestingFlight] {
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
//        print("􀪹 Deleted flight")
    }

    func add(ticket: Ticket) {
        tickets[ticket.id] = ticket
//        print("􀪹 Added ticket")
    }

    func update(ticket: Ticket) {
        tickets[ticket.id] = ticket
//        print("􀪹 Updated ticket")
    }
}

let mockServer = MockServer()
