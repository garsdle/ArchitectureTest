import SwiftUI

// FIXME: The problem is we now have one god object updating EVERYTHING. Also there is a lot of bubbling up going on via closures...

struct MainView: View {
    @StateObject var appData = AppData()

    var body: some View {
        NavigationView {
            List {
                Text("Total Tickets: \(appData.flights.map(\.tickets.count).reduce(0, +))")

                ForEach(appData.flights) { flight in
                    NavigationLink(flight.name,
                                   destination: FlightView(flight: flight,
                                                           onAddTicket: { appData.addTicket(flightId: flight.id) },
                                                           onTicketUpdate: { appData.update(ticket: $0, flightId: flight.id) })
                    )
                }
                .onDelete(perform: appData.deleteFlight(at:))
            }
            .listStyle(GroupedListStyle())
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
