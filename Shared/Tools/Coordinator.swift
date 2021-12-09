//
//  Coordinator.swift
//  ArchitectureTest
//
//  Created by Manny on 12/8/21.
//

import SwiftUI

protocol Coordinator {
    associatedtype ViewBody: View
    var view: ViewBody { get }
}

struct CoordinatorView<C: Coordinator>: View {
    let coordinator: C
    
    var body: some View {
        coordinator.view
    }
}
