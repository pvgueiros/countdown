import Foundation

public struct AddDateOfInterestUseCase {
    private let repository: DateOfInterestRepository

    public init(repository: DateOfInterestRepository) {
        self.repository = repository
    }

    public func execute(
        title: String,
        date: Date,
        iconSymbolName: String,
        entryColorHex: String,
        createdAt: Date = Date()
    ) async throws {
        let item = DateOfInterest(
            title: title,
            date: date,
            iconSymbolName: iconSymbolName,
            entryColorHex: entryColorHex,
            createdAt: createdAt
        )
        try await repository.add(item)
    }
}


