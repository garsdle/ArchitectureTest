import SwiftUI

struct FlightsState: Equatable {
    static func == (lhs: FlightsState, rhs: FlightsState) -> Bool {
        lhs.ticketCount == rhs.ticketCount && lhs.sortedFlights == rhs.sortedFlights
    }

    let ticketCount: String
    let sortedFlights: [Flight]

    private let appStore: AppStore

    func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }

        let flight = sortedFlights[index]
        appStore.delete(flightId: flight.id)
    }
}

extension FlightsState {
    init(appStore: AppStore) {
        self.appStore = appStore
        print(appStore.state.tickets.count)
        self.ticketCount = "Total Tickets: \(appStore.state.tickets.count)"

        self.sortedFlights = appStore.state.flights.values.sorted(by: { $0.name > $1.name })
    }
}

struct FlightsView: View {
    @Environment(\.appStore) var appStore
    @Scoped var state: FlightsState

    var body: some View {
        List {
            Text(state.ticketCount)

            ForEach(state.sortedFlights) { flight in
                NavigationLink(flight.name,
                               destination: FlightView(state: appStore.scope({ FlightState(appState: $0, flight: flight) })))
            }
            .onDelete(perform: state.delete(indexSet:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Flights")
    }
}

//struct FlightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightsView(state: appStore.scope(FlightsState.init(appState:)))
//    }
//}
//
