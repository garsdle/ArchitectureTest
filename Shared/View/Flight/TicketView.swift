import SwiftUI

class TicketViewModel: ObservableObject {
    @Published var ticket: Ticket
    
    init(ticket: Ticket) {
        self.ticket = ticket
    }
}

struct TicketView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .navigationTitle("Ticket Detail View")
    }
}

struct Flight_Previews: PreviewProvider {
    static var previews: some View {
        FlightScreen(flightName: "Test",
                     tickets: [.mock],
                     onSelectTicket: { _ in },
                     onDelete: { _ in },
                     onAddTicket: { },
                     onSwitchToAircraft: {})
    }
}
