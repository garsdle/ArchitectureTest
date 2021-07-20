//import SwiftUI
//
//struct TicketRow: View {
//    let ticket: Ticket
//    let onTicketUpdate: (Ticket) -> Void
//
//    @State private var isPresentingEditor = false
//
//    var body: some View {
//        Text(ticket.name)
//            .contextMenu {
//                Button(action: {
//                    isPresentingEditor.toggle()
//                }, label: {
//                    Label("Edit", systemImage: "pencil")
//                })
//            }
//            .sheet(isPresented: $isPresentingEditor) {
//                TicketView(ticket: ticket, onSave: onTicketUpdate)
//            }
//    }
//}
//
//struct TicketRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TicketRow(ticket: .mock, onTicketUpdate: { _ in })
//    }
//}
