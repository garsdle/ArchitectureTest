import Foundation
import Combine

class FlightService: ObservableObject {
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

    func ticketsByName() -> AnyPublisher<[Ticket], Never> {
        $flight.compactMap(\.?.tickets)
            .map {
                $0.sorted { $0.name > $1.name }
            }
            .eraseToAnyPublisher()
    }

    func guestCount() -> AnyPublisher<Int, Never> {
        ticketsByName().map(\.count).eraseToAnyPublisher()
    }

    func delete(_ ticketId: Ticket.ID) {
        flight?.tickets.removeAll { $0.id == ticketId }

        api.deleteTicket(ticketId)
            .replaceError(with: ())
            .sink(receiveValue: {})
            .store(in: &cancellables)
    }

    func addTicket(flightId: Flight.ID) {
        let newTicket = Ticket(id: uuidGenerator(), flightId: flightId)
        flight?.tickets.append(newTicket)
        
        api.addTicket(newTicket)
            .sink { completion in
                print(completion)
            } receiveValue: {

            }
            .store(in: &cancellables)
    }
}
