import SwiftUI

struct TicketRow: View {
    @Binding var ticket: Ticket
    @State var isPresentingEditor = false

    var body: some View {
        Text(ticket.name)
            .contextMenu {
                Button(action: {
                    isPresentingEditor.toggle()
                }, label: {
                    Label("Edit", systemImage: "pencil")
                })
            }
            .sheet(isPresented: $isPresentingEditor) {
                TicketView(ticket: ticket) { ticket in
                    //Update API here?
                    self.ticket = ticket
                }
            }
    }
}

struct TicketRow_Previews: PreviewProvider {
    static var previews: some View {
        TicketRow(ticket: .constant(.mock))
    }
}
