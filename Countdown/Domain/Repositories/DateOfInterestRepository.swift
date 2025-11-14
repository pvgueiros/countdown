import Foundation

public protocol DateOfInterestRepository {
    func fetchAll() async throws -> [DateOfInterest]
    func add(_ item: DateOfInterest) async throws
    func update(_ item: DateOfInterest) async throws
}


