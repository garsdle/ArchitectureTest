import SwiftUI

let appData = AppData()

struct MainView: View {
    var body: some View {
        NavigationView {
            FlightsView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: appData.loadFlights)
        .onAppear(perform: appData.loadTickets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
