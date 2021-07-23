import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            FlightsView(state: appStore.scope(map(appState:)))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            appStore.loadFlights()
            appStore.loadTickets()
        }
    }

    func map(appState: AppState) -> FlightsState {
        print(appState.tickets.count)
        return FlightsState(ticketCount: appState.tickets.count,
                            sortedFlights: appState.flights.values.sorted(by: { $0.name > $1.name }) )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
