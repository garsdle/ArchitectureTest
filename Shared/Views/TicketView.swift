import SwiftUI

struct TicketView: View {
    @Environment(\.presentationMode) @Binding var presentationMode

    @State var ticket: Ticket
    let onSave: (Ticket) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Ticket holder name", text: $ticket.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                    Button("Cancel") {
                        presentationMode.dismiss()
                    }
                }

                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Button("Save") {
                        onSave(ticket)
                        presentationMode.dismiss()
                    }
                }
            }
            .navigationTitle(ticket.name)
        }
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(ticket: .mock,
                   onSave: { _ in })
    }
}
