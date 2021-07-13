import SwiftUI

struct FlightsView: View {
    @ObservedObject var flightService: FlightService
    @ScopedGet(getter: ticketService.ticketCount, publisher: ticketService.$tickets.count()) var ticketCount

    var body: some View {
        List {
            Text("Total Tickets: \(ticketCount)")

            ForEach(flightService.sortedFlights) { flight in
                NavigationLink(flight.name, destination: FlightView(flight: flight))
            }
            .onDelete(perform: flightService.delete(_:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Flights")
    }
}

struct FlightsView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsView(flightService: FlightService())
    }
}
