//import SwiftUI
//
//struct FlightView: View {
//    @ScopedGet var tickets: [Ticket]
//    @ScopedGet var flight: Flight
//
//    var body: some View {
//        List(tickets) { ticket in
//            TicketRow(ticket: ticket, onTicketUpdate: appData.update(ticket:))
//        }
//        .listStyle(InsetGroupedListStyle())
//        .navigationBarItems(trailing: Button("Add", action: { appData.addTicket(flightId: flight.id) }))
//        .navigationTitle(flight.name)
//    }
//}
//
//
//struct FlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightView(tickets: appData, flight: .mock)
//    }
//}
