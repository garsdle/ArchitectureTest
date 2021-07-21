import SwiftUI

let appData = AppData()

struct MainView: View {
    var body: some View {
        NavigationView {
            FlightsView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            appData.loadFlights()
            appData.loadTickets()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
