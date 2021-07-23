import Foundation

let current = AppEnvironment.mock

struct AppEnvironment {
    let api: API

    static var mock: AppEnvironment {
        AppEnvironment(api: .mock)
    }
}



