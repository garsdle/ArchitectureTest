import SwiftUI

struct FlightsView: View {
    @ScopedGet(getter: appData.ticketCount, publisher: appData.$tickets.map(\.count)) var ticketCount
    @ScopedGet(getter: appData.sortedFlights, publisher: appData.$sortedFlights) var sortedFlights

    var body: some View {
        List {
            Text("Total Tickets: \(ticketCount)")

            ForEach(sortedFlights) { flight in
                NavigationLink(flight.name, destination: FlightView(flightId: flight.id))
            }
            .onDelete(perform: appData.delete(_:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Flights")
    }
}

struct FlightsView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsView()
    }
}
