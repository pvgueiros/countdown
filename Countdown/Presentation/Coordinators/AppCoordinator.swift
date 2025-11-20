import SwiftUI

public protocol Coordinator {
    associatedtype Root: View
    func rootView() -> Root
}

public struct AppCoordinator: Coordinator {
    public init() {}
    public func rootView() -> some View {
        let repository = UserDefaultsDateOfInterestRepository(userDefaults: AppGroupUserDefaults.make())
        let viewModel = DateListViewModel(repository: repository)
        return CountdownListScreen(viewModel: viewModel)
    }
}


