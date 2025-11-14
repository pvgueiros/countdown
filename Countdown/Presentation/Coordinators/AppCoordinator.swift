import SwiftUI

public protocol Coordinator {
    associatedtype Root: View
    func rootView() -> Root
}

public struct AppCoordinator: Coordinator {
    public init() {}
    public func rootView() -> some View {
        ContentView()
    }
}


