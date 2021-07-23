import SwiftUI

struct FlightsState: Equatable {
    var ticketCount: Int = 0
    var sortedFlights: [Flight] = []
}

extension FlightsState {
    init(appState: AppState) {
        print(appState.tickets.count)
        self.ticketCount = appState.tickets.count

        self.sortedFlights = appState.flights.values.sorted(by: { $0.name > $1.name })
    }
}

struct FlightsView: View {
    @Environment(\.appStore) var appStore
    @Scoped var state: FlightsState

    var body: some View {
        List {
            Text("Total Tickets: \(state.ticketCount)")

            ForEach(state.sortedFlights) { flight in
                NavigationLink(flight.name,
                               destination: FlightView(state: appStore.scope({ FlightState(appState: $0, flight: flight) })))
            }
            .onDelete(perform: delete)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Flights")
    }

    func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }

        let flight = state.sortedFlights[index]
        appStore.delete(flightId: flight.id)
    }
}

struct FlightsView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsView(state: appStore.scope(FlightsState.init(appState:)))
    }
}
