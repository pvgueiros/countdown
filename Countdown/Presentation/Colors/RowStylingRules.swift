import SwiftUI

public enum RowStylingRules {
    /// Returns the hex color to be used for the countdown pill (foreground/background base).
    /// - Parameters:
    ///   - isPast: Whether the item date is in the past.
    ///   - entryColorHex: The entry color hex associated with the item.
    /// - Returns: Hex string to use as the base color for the pill. Past items map to gray.
    public static func badgeColorHex(hasGrayBackground: Bool, entryColorHex: String) -> String {
        if hasGrayBackground { return "#808080" }
        return entryColorHex
    }
}


