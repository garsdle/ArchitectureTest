import Foundation
import Combine
import SwiftUI

class ScopedGetObservable<T>: ObservableObject {
    var cancellable: AnyCancellable?

    let getter: () -> T

    init<P>(getter: @autoclosure @escaping () -> T, publisher: P) where P: Publisher, P.Failure == Never {
        self.getter = getter
        cancellable = publisher.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}

@propertyWrapper
struct ScopedGet<T>: DynamicProperty {
    var wrappedValue: T {
        scopedObservable.getter()
    }

    @ObservedObject private var scopedObservable: ScopedGetObservable<T>

    init<P>(getter: @autoclosure @escaping () -> T, publisher: P) where P: Publisher, P.Failure == Never {
        self.scopedObservable = .init(getter: getter(), publisher: publisher)
    }
}
