import SwiftUI

struct TicketView: View {
    @Binding var name: String
    
    var body: some View {
        TextField("Name", text: $name)
            .textFieldStyle(.roundedBorder)
            .padding()
            .navigationTitle("Ticket Detail View")
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(name: .constant("Test"))
    }
}
