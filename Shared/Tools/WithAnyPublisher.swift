import SwiftUI
import Combine

struct WithAnyPublisher<T, Content: View>: View {
    @State var state: T
    let publisher: AnyPublisher<T, Never>
    let content: (T) -> Content
    
    init(_ publisher: AnyPublisher<T, Never>, initialValue: T, @ViewBuilder content: @escaping (T) -> Content) {
        self.publisher = publisher
        self._state = .init(initialValue: initialValue)
        self.content = content
    }
    
    var body: some View {
        content(state)
            .onReceive(publisher) { value in
                state = value
            }
    }
}

struct WithValueSubject<T, Content: View>: View {
    @State var state: T
    let publisher: CurrentValueSubject<T, Never>
    let content: (T) -> Content
    
    init(_ publisher: CurrentValueSubject<T, Never>, @ViewBuilder content: @escaping (T) -> Content) {
        self.publisher = publisher
        self._state = .init(initialValue: publisher.value)
        self.content = content
    }
    
    var body: some View {
        content(state)
            .onReceive(publisher) { value in
                state = value
            }
    }
}
