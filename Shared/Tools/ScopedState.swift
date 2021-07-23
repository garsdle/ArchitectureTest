import Foundation
import Combine
import SwiftUI
import AVFoundation

class ScopedStateObservable<T>: ObservableObject {
    @Published var state: T

    init<P>(initialValue: T, publisher: P) where P: Publisher, P.Failure == Never, P.Output == T {
        self.state = initialValue
        publisher.assign(to: &$state)
    }
}

@propertyWrapper
struct Scoped<ScopedState>: DynamicProperty {
    var wrappedValue: ScopedState {
        scopedObservable.state
    }

    @StateObject var scopedObservable: ScopedStateObservable<ScopedState>
}

@dynamicMemberLookup
class Store<State: Equatable>: ObservableObject {
    @Published var state: State

    init(initialState: State) {
        self.state = initialState
    }

    func scope<Substate: Equatable>(_ mapping: @escaping (State) -> Substate) -> Scoped<Substate> {
        Scoped(scopedObservable: ScopedStateObservable(initialValue: mapping(self.state),
                                                       publisher: self.$state.map(mapping).removeDuplicates()))
    }

    func scope<Substate: Equatable>(_ mapping: @escaping (State) -> Substate?, defaultValue: Substate) -> Scoped<Substate> {
        Scoped(scopedObservable: ScopedStateObservable(initialValue: mapping(self.state) ?? defaultValue,
                                                       publisher: self.$state.compactMap(mapping).removeDuplicates()))
    }

    // Identity
    func scope() -> Scoped<State> {
        Scoped(scopedObservable: ScopedStateObservable(initialValue: self.state,
                                                       publisher: self.$state.removeDuplicates()))
    }

    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        state[keyPath: keyPath]
    }
}

struct ScopedGetView<State: Equatable, Content: View>: View {
    @StateObject var store: Store<State>

    var content: (Scoped<State>) -> Content

    init(_ initialValue: State, @ViewBuilder content: @escaping (Scoped<State>) -> Content) {
        self._store = .init(wrappedValue: .init(initialState: initialValue))
        self.content = content
    }

    var body: some View {
        content(store.scope())
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
