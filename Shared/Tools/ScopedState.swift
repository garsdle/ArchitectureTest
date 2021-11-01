import Foundation
import SwiftUI

struct WithViewModel<T: ObservableObject, Content: View>: View {
    @ObservedObject private var viewModel: T

    private var content: (T) -> Content

    init(_ model: T, @ViewBuilder content: @escaping (T) -> Content) {
        self._viewModel = .init(wrappedValue: model)
        self.content = content
    }

    var body: some View {
        content(viewModel)
    }
}
