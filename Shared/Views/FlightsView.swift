import SwiftUI

struct FlightsState: Equatable {
    var ticketCount: Int = 0
    var sortedFlights: [Flight] = []
}

struct FlightsView: View {
    @ScopedGet var state: FlightsState

    var body: some View {
        List {
            Text("Total Tickets: \(state.ticketCount)")

            ForEach(state.sortedFlights) { flight in
                NavigationLink(flight.name,
                               destination:
                                FlightView(tickets: appStore.scope({ map(appState: $0, flightId: flight.id) }),
                                           flight: appStore.scope(\.flights[flight.id], defaultValue: flight))
                               )
            }
            .onDelete(perform: appStore.delete(_:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Flights")
    }


    
    func map(appState: AppState, flightId: Flight.ID) -> [Ticket] {
        appState.tickets.values
            .filter { $0.flightId == flightId }
            .sorted { $0.name < $1.name }
    }
}

struct FlightsView_Previews: PreviewProvider {
    static var previews: some View {
        ScopedGetView(FlightsState(ticketCount: 3,
                                   sortedFlights: [])) {
            FlightsView(state: $0)
        }
    }
}
