import Foundation
import Combine

class FlightController {
    @Published private(set) var flight: NestingFlight?

    private let api: API
    private let uuidGenerator: () -> UUID
    private var cancellables = Set<AnyCancellable>()

    init(api: API, uuidGenerator: @escaping () -> UUID) {
        self.api = api
        self.uuidGenerator = uuidGenerator

        api.getFlight()
            .replaceError(with: nil)
            .assign(to: &$flight)
    }

    func publisher(ticketId: Ticket.ID) -> AnyPublisher<Ticket?, Never> {
        $flight
            .map(\.?.tickets[ticketId])
            .eraseToAnyPublisher()
    }

    func ticketsByName() -> AnyPublisher<[Ticket], Never> {
        $flight.compactMap(\.?.tickets.values)
            .map { $0.sorted { $0.name < $1.name } }
            .eraseToAnyPublisher()
    }

    func ticketCount() -> AnyPublisher<Int, Never> {
        ticketsByName().map(\.count).eraseToAnyPublisher()
    }

    func delete(_ ticketId: Ticket.ID) {
        flight?.tickets.removeValue(forKey: ticketId)

        api.deleteTicket(ticketId)
            .replaceError(with: ())
            .sink(receiveValue: {})
            .store(in: &cancellables)
    }

    func addTicket(flightId: Flight.ID) {
        let newTicket = Ticket(id: uuidGenerator(), flightId: flightId)
        flight?.tickets[newTicket.id] = newTicket
        
        api.addTicket(newTicket)
            .sink { completion in
                print(completion)
            } receiveValue: {

            }
            .store(in: &cancellables)
    }

    func update(name: String, ticketId: Ticket.ID) {
        guard var ticket = self.flight?.tickets[ticketId] else {
            return
        }
        ticket.name = name
        self.flight?.tickets[ticketId] = ticket
        api.updateTicket(ticket)
            .sink { completion in
                print(completion)
            } receiveValue: {

            }
            .store(in: &cancellables)
    }
}
