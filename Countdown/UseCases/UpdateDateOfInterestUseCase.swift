import Foundation

public struct UpdateDateOfInterestUseCase {
    private let repository: DateOfInterestRepository

    public init(repository: DateOfInterestRepository) {
        self.repository = repository
    }

    public func execute(_ item: DateOfInterest) async throws {
        try await repository.update(item)
    }
}


