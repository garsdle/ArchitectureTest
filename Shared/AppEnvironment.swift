import Foundation

let current = AppEnvironment.mock

struct AppEnvironment {
    let flightService: FlightService

    static var mock: AppEnvironment {
        let api = API.mock
        let uuidGenerator: () -> UUID = UUID.init
        return AppEnvironment(flightService: .init(api: api, uuidGenerator: uuidGenerator))
    }
}
