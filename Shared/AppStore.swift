import Foundation
import Combine

// This looks a lot like just an in memory DB now...
struct AppState: Equatable {
    var flights: [Flight.ID: Flight] = [:]
    var tickets: [Ticket.ID: Ticket] = [:]
}

class AppStore: Store<AppState> {
    private var cancelBag = Set<AnyCancellable>()
}

extension AppStore {
    func loadFlights() {
        current.api.getFlights()
            .replaceError(with: [:])
            .sink { [weak self] flights in
                self?.state.flights = flights
            }
            .store(in: &cancelBag)
    }

    func delete(flightId: Flight.ID) {
        state.tickets = state.tickets.filter { $0.value.flightId != flightId}
        state.flights.removeValue(forKey: flightId)
        
        current.api.deleteFlight(flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
    }
}

extension AppStore {
    var ticketCount: Int {
        state.tickets.count
    }

    func tickets(for flightId: Flight.ID) -> [Ticket] {
        state.tickets.values
            .filter { $0.flightId == flightId }
            .sorted { $0.name < $1.name }
    }

    func addTicket(flightId: Flight.ID) {
        let newTicket = Ticket(id: UUID(), flightId: flightId)

        current.api.addTicket(newTicket, flightId)
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancelBag)

        state.tickets[newTicket.id] = newTicket
    }

    func update(ticket: Ticket) {
        current.api.updateTicket(ticket)
            .sink { completion in
                // TODO: Do something with error!
            } receiveValue: {
                // TODO: Should it only update locally on success?
            }
            .store(in: &cancelBag)

        // TODO: And what about persisting to disk

        state.tickets[ticket.id] = ticket
    }

    func loadTickets() {
        current.api.getTickets()
            .replaceError(with: [:])
            .sink { [weak self] tickets in
                self?.state.tickets = tickets
            }
            .store(in: &cancelBag)
    }
}

import SwiftUI

extension EnvironmentValues {
    var appStore: AppStore {
        get { self[AppStore.self] }
        set { self[AppStore.self] = newValue }
    }
}

extension AppStore: EnvironmentKey {
    static var defaultValue: AppStore {
        AppStore(initialState: .init())
    }
}
