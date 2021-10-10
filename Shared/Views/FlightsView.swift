import SwiftUI

struct FlightsState: Equatable {
    let ticketCount: String
    let sortedFlights: [Flight]
}

extension FlightsState {
    init(appState: AppState) {
        print(appState.tickets.count)
        self.ticketCount = "Total Tickets: \(appState.tickets.count)"
        self.sortedFlights = appState.flights.values.sorted(by: { $0.name > $1.name })
    }
}

struct FlightsEnvironment {
    let flightsPublisher: AnyPublisher<[Flight], Never>
}

struct FlightsController {
    func delete(appStore: AppStore, indexSet: IndexSet) {
        guard let index = indexSet.first else { return }

        let flight = sortedFlights[index]
        appStore.delete(flightId: flight.id)
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
            .onDelete(perform: { state.delete(appStore: appStore, indexSet: $0) })
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
