import SwiftUI

struct MainView: View {
    @StateObject var appData = AppData()

    var body: some View {
        NavigationView {
            List {
                Text("Total Tickets: \(appData.flights.map(\.tickets.count).reduce(0, +))")

                ForEach($appData.flights) { $flight in
                    NavigationLink(flight.name,
                                   destination: FlightView(flight: $flight))
                }
                .onDelete { indexSet in
                    appData.flights.remove(atOffsets: indexSet)
                }
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
