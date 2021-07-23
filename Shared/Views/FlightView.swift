import SwiftUI
import Combine

struct FlightState: Equatable {
    let tickets: [Ticket]
    let flight: Flight
}

extension FlightState {
    init(appState: AppState, flight: Flight) {
        tickets = appState.tickets.values
            .filter { $0.flightId == flight.id }
            .sorted { $0.name < $1.name }

        self.flight = flight
    }
}
struct FlightView: View {
    @Environment(\.appStore) var appStore

    @Scoped var state: FlightState

    var body: some View {
        List(state.tickets) { ticket in
            TicketRow(ticket: ticket, onTicketUpdate: appStore.update(ticket:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Add", action: { appStore.addTicket(flightId: state.flight.id) }))
        .navigationTitle(state.flight.name)
    }
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(state: appStore.scope( { FlightState(appState: $0, flight: .mock) }))
    }
}

