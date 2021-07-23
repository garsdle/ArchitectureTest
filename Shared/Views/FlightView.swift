import SwiftUI
import Combine

struct FlightView: View {
    @ScopedGet var tickets: [Ticket]
    @ScopedGet var flight: Flight

    var body: some View {
        List(tickets) { ticket in
            TicketRow(ticket: ticket, onTicketUpdate: appStore.update(ticket:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Add", action: { appStore.addTicket(flightId: flight.id) }))
        .navigationTitle(flight.name)
    }
}


//struct FlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightView(tickets: <#T##ScopedGet<[Ticket]>#>, flight: <#T##ScopedGet<Flight>#>)
//    }
//}
//
