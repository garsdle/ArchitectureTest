//
//  API.swift
//  ArchitectureTest
//
//  Created by Emmanuel Garsd on 5/6/21.
//

import Foundation
import Combine

let current = AppEnvironment.mock

struct AppEnvironment {
    let api: API
}

extension AppEnvironment {
    static var mock: AppEnvironment {
        AppEnvironment(api: .mock)
    }
}



