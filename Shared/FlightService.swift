import Foundation
import Combine

class FlightService: ObservableObject {
    @Published private(set) var flights: [Flight.ID: Flight] = [:] {
        didSet {
            sortedFlights = flightService.flights.values.sorted(by: { $0.name < $1.name })
        }
    }
    @Published private(set) var selectedFlightId: Flight.ID?

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
