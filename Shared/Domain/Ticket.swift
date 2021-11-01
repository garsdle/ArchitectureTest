//
//  Ticket.swift
//  ArchitectureTest
//
//  Created by Emmanuel Garsd on 10/31/21.
//

import Foundation

struct Ticket: Identifiable, Equatable {
    let id: UUID
    let flightId: Flight.ID
    var name: String

    init(id: UUID, flightId: UUID) {
        self.id = id
        self.flightId = flightId
        self.name = id.uuidString
    }

    static var mock: Ticket {
        Ticket(id: .init(), flightId: .init())
    }
}
