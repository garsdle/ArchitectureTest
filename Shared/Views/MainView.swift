import SwiftUI

let flightService = FlightService()
let ticketService = TicketService()

struct MainView: View {
    var body: some View {
        NavigationView {
            FlightsView(flightService: flightService)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: flightService.loadFlights)
        .onAppear(perform: ticketService.loadTickets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


