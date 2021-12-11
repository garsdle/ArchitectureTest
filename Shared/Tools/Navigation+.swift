import SwiftUI
import SwiftUINavigation

extension View {
    func navigation<Content: View>(isActive: Binding<Bool>, destination: () -> Content) -> some View {
        self.overlay(
            NavigationLink(isActive: isActive, destination: destination) {
                EmptyView()
            }
        )
    }
    
    func navigation<Content: View, Value>(item: Binding<Value?>, destination: @escaping (Binding<Value>) -> Content) -> some View {
        self.overlay(
            NavigationLink(unwrapping: item, destination: destination, onNavigate: { _ in }, label: {
                EmptyView()
            })
        )
    }
}
