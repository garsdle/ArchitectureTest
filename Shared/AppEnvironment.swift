import Foundation

struct AppEnvironment {
    let flightController: FlightController

    static var mock: AppEnvironment {
        let api = API.mock
        let uuidGenerator: () -> UUID = UUID.init
        return AppEnvironment(flightController: .init(api: api, uuidGenerator: uuidGenerator))
    }
}
