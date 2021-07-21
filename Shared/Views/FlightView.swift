import SwiftUI
import Combine
import PublisherView

struct FlightView: View {
    let flightId: Flight.ID

    var ticketsPublisher: AnyPublisher<[Ticket], Never> {
        appData.$tickets.map(\.values)
            .shareReplay()
            .map { tickets in
                tickets.filter { $0.flightId == flightId}
            }
            .eraseToAnyPublisher()
    }

    var flightPublisher: AnyPublisher<Flight, Never> {
        appData.$flights
            .shareReplay()
            .compactMap(\.[flightId])
            .eraseToAnyPublisher()
    }

    var body: some View {
        PublisherView(publisher: ticketsPublisher) { tickets in
            PublisherView(publisher: flightPublisher) { flight in
                List(tickets) { ticket in
                    TicketRow(ticket: ticket, onTicketUpdate: appData.update(ticket:))
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarItems(trailing: Button("Add", action: { appData.addTicket(flightId: flight.id) }))
                .navigationTitle(flight.name)
            }
        }
    }
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(flightId: .init())
    }
}

extension Publisher {
    func shareReplay() -> AnyPublisher<Output, Failure> {
        let subject = CurrentValueSubject<Output?, Failure>(nil)

        return map { $0 }
            .multicast(subject: subject)
            .autoconnect()
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
