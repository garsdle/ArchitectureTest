import SwiftUI

struct AppView: View {
    @Environment(\.appStore) var appStore

    var body: some View {
        NavigationView {
            FlightsView(state: appStore.scope( { _ in FlightsState(appState: appStore.state) }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            appStore.loadFlights()
            appStore.loadTickets()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
