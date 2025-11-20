import SwiftUI

public enum RowStylingRules {
    public static func badgeColorHex(hasGrayBackground: Bool, eventColorHex: String) -> String {
        if hasGrayBackground { return "#808080" }
        return eventColorHex
    }
}


