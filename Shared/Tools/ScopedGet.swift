import Foundation
import Combine
import SwiftUI
import AVFoundation

class ScopedObservable<T>: ObservableObject {
    let getter: () -> T

    private var cancellable: AnyCancellable?

    init<P>(getter: @autoclosure @escaping () -> T, publisher: P) where P: Publisher, P.Failure == Never {
        self.getter = getter
        cancellable = publisher.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}

@propertyWrapper
struct ScopedGet<ScopedState>: DynamicProperty {
    var wrappedValue: ScopedState {
        scopedObservable.getter()
    }

    @ObservedObject private var scopedObservable: ScopedObservable<ScopedState>

    init<P>(getter: @autoclosure @escaping () -> ScopedState, publisher: P) where P: Publisher, P.Failure == Never {
        self.scopedObservable = .init(getter: getter(), publisher: publisher)
    }

    func scope<Substate>(_ keyPath: WritableKeyPath<ScopedState, Substate>) -> ScopedGet<Substate> {
        ScopedGet<Substate>(getter: wrappedValue[keyPath: keyPath], publisher: scopedObservable.objectWillChange)
    }
}

class Store<State: Equatable>: ObservableObject {
    @Published var state: State

    init(initialState: State) {
        self.state = initialState
    }

    func scope<Substate: Equatable>(_ mapping: @escaping (State) -> Substate) -> ScopedGet<Substate> {
        ScopedGet(getter: mapping(self.state),
                  publisher: $state.map(mapping).removeDuplicates())
    }

    func scope<Substate: Equatable>(_ mapping: @escaping (State) -> Substate?, defaultValue: Substate) -> ScopedGet<Substate> {
        ScopedGet(getter: mapping(self.state) ?? defaultValue,
                  publisher: $state.map(mapping).removeDuplicates())
    }

    func scope() -> ScopedGet<State> {
        ScopedGet(getter: self.state,
                  publisher: $state.removeDuplicates())
    }
}

struct ScopedGetView<State: Equatable, Content: View>: View {
    @StateObject var store: Store<State>

    var content: (ScopedGet<State>) -> Content

    init(_ initialValue: State, @ViewBuilder content: @escaping (ScopedGet<State>) -> Content) {
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
