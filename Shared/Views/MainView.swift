import SwiftUI

// FIXME: The problem is we now have one god object updating EVERYTHING. Also there is a lot of bubbling up going on via closures...
var appData = AppData()

struct MainView: View {
    @ScopedGet(getter: appData.ticketCount,
               publisher: appData.$flights) var ticketCount: Int

    @ScopedGet(getter: appData.flights,
               publisher: appData.$flights) var flights: [NestingFlight]

    var body: some View {
        NavigationView {
            List {
                Text("Total Tickets: \(ticketCount)")

                ForEach(flights) { flight in
                    NavigationLink(flight.name,
                                   destination: FlightView(flight: flight,
                                                           onAddTicket: { appData.addTicket(flightId: flight.id) },
                                                           onTicketUpdate: { appData.update(ticket: $0, flightId: flight.id) })
                    )
                }
                .onDelete(perform: appData.deleteFlight(at:))
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Flights")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: appData.loadFlights)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

