import SwiftUI

struct FlightView: View {
    let flight: Flight

    var body: some View {
        TicketsView(ticketsService: ticketService, flightId: flight.id)
        .navigationTitle(flight.name)
    }
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(flight: .mock)
    }
}
