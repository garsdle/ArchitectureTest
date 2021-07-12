import SwiftUI

struct TicketsView: View {
    @ObservedObject var ticketsService: TicketService
    //FIXME: We end up with this weird mix of value types and services
    let flightId: Flight.ID

    var body: some View {
        List {
            Section(header: Text("Tickets")) {
                ForEach(ticketsService.tickets(for: flightId)) { ticket in
                    TicketRow(ticket: ticket, onTicketUpdate: ticketsService.update(ticket:))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Add", action: { ticketsService.addTicket(flightId: flightId) }))
    }
}

struct TicketsView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsView(ticketsService: TicketService(), flightId: .init())
    }
}
