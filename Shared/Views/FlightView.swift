import SwiftUI

struct FlightView: View {
    @Binding var flight: NestingFlight

    var body: some View {
        List {
            Section(header: Text("Tickets")) {
                ForEach(flight.tickets.indexed(), id: \.element.id) { index, ticket in
                    TicketRow(ticket: $flight.tickets[index])
                }
                .onDelete(perform: { indexSet in
                    flight.tickets.remove(atOffsets: indexSet)
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(flight.name)
        .navigationBarItems(trailing: Button("Add", action: addTicket))
    }

    func addTicket() {
        flight.tickets.append(Ticket(id: UUID(), flightId: flight.id))
    }
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(flight: .constant(.init(id: .init(), tickets: [.mock])))
    }
}
