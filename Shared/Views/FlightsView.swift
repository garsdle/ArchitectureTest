import SwiftUI

struct FlightsView: View {
    @ObservedObject var flightService: FlightService
    @ScopedGet(getter: ticketService.ticketCount, publisher: ticketService.$tickets) var ticketCount

    // TODO: This is bad for performance!
    var sortedFlights: [Flight] {
        flightService.flights.values.sorted(by: { $0.name < $1.name })
    }

    var body: some View {
        List {
            Text("Total Tickets: \(ticketCount)")

            ForEach(sortedFlights) { flight in
                NavigationLink(flight.name, destination: FlightView(flight: flight))
            }
            .onDelete { indexSet in
                indexSet
                    .map { sortedFlights[$0] }
                    .forEach {
                        flightService.delete(flightId: $0.id)
                    }
            }
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
