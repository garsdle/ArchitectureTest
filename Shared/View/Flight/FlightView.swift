import SwiftUI
import Combine

struct FlightView: View {
    let flightName: String
    let tickets: [Ticket]
    let onSelectTicket: (Ticket) -> Void
    let onDelete: (Ticket) -> Void
    let onAddTicket: () -> Void
    let onSwitchToAircraft: () -> Void
    
    var body: some View {
        List {
            ForEach(tickets) { ticket in
                Button(action: { onSelectTicket(ticket) }) {
                    TicketRow(name: ticket.name)
                }
            }
            .onDelete { indexSet in
                guard let firstIndex = indexSet.first else { return }
                onDelete(tickets[firstIndex])
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Switch to Aircraft", action: onSwitchToAircraft)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Add Ticket", action: onAddTicket)
            }
        }
        .navigationTitle("Ticket View")
    }
    
    struct TicketRow: View {
        let name: String
        
        var body: some View {
            Text(name)
        }
    }
}

struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(flightName: "Test",
                   tickets: [.mock],
                   onSelectTicket: { _ in },
                   onDelete: { _ in },
                   onAddTicket: { },
                   onSwitchToAircraft: {})
    }
}
