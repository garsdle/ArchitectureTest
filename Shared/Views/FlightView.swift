import SwiftUI

struct FlightView: View {
    let flight: NestingFlight
    let onAddTicket: () -> Void
    let onTicketUpdate: (Ticket) -> Void

    var body: some View {
        List {
            Section(header: Text("Tickets")) {
                ForEach(flight.tickets) { ticket in
                    TicketRow(ticket: ticket, onTicketUpdate: onTicketUpdate)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(flight.name)
        .navigationBarItems(trailing: Button("Add", action: onAddTicket))
    }
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(flight: .mock,
                   onAddTicket: { },
                   onTicketUpdate:  { _ in })
    }
}
