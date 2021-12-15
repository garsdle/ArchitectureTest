import Foundation

struct AppEnvironment {
    let api = API.mock
    let uuidGenerator: () -> UUID = UUID.init
}

let current = AppEnvironment()
