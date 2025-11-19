import Foundation
import Combine
internal import os

@MainActor
public final class AddEditDateViewModel: ObservableObject {
    public enum Mode {
        case add
        case edit(DateOfInterest)
    }

    // Inputs
    @Published public var title: String = ""
    @Published public var date: Date = Date()
    @Published public var hasCustomDate: Bool = false
    @Published public var iconSymbolName: String = "star"
    @Published public var entryColorHex: String = "#FF9500"

    // State
    @Published public private(set) var isSubmitting: Bool = false

    private let repository: any DateOfInterestRepository
    private let addUseCase: AddDateOfInterestUseCase
    private let updateUseCase: UpdateDateOfInterestUseCase
    private let mode: Mode
    private let onCompleted: () -> Void

    public init(
        repository: any DateOfInterestRepository,
        mode: Mode,
        onCompleted: @escaping () -> Void
    ) {
        self.repository = repository
        self.addUseCase = AddDateOfInterestUseCase(repository: repository)
        self.updateUseCase = UpdateDateOfInterestUseCase(repository: repository)
        self.mode = mode
        self.onCompleted = onCompleted

        switch mode {
        case .add:
            // Accept today's date by default for add mode
            self.hasCustomDate = true
        case .edit(let item):
            self.title = item.title
            self.date = item.date
            self.hasCustomDate = true
            self.iconSymbolName = item.iconSymbolName
            self.entryColorHex = item.entryColorHex
        }
    }

    public var isEditMode: Bool {
        if case .edit = mode { return true }
        return false
    }

    public var headerTitle: String { isEditMode ? "Edit Countdown" : "New Countdown" }
    public var ctaTitle: String { isSubmitting ? (isEditMode ? "Saving..." : "Adding...") : (isEditMode ? "Save Changes" : "Add Countdown") }

    public var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasCustomDate
    }

    public func submit() async {
        guard isValid else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        switch mode {
        case .add:
            do {
                try await addUseCase.execute(
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    date: date,
                    iconSymbolName: iconSymbolName,
                    entryColorHex: entryColorHex
                )
                onCompleted()
            } catch {
                Log.general.error("Failed to add item: \(String(describing: error), privacy: .public)")
            }
        case .edit(let existing):
            do {
                let updated = DateOfInterest(
                    id: existing.id,
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    date: date,
                    iconSymbolName: iconSymbolName,
                    entryColorHex: entryColorHex,
                    createdAt: existing.createdAt
                )
                try await updateUseCase.execute(updated)
                onCompleted()
            } catch {
                Log.general.error("Failed to update item: \(String(describing: error), privacy: .public)")
            }
        }
    }
}


