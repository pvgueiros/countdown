import SwiftUI

public extension Color {
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        if hexString.count == 6, let value = UInt32(hexString, radix: 16) {
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            self = Color(red: r, green: g, blue: b)
            return
        }
        if hexString.count == 8, let value = UInt32(hexString, radix: 16) {
            let r = Double((value >> 24) & 0xFF) / 255.0
            let g = Double((value >> 16) & 0xFF) / 255.0
            let b = Double((value >> 8) & 0xFF) / 255.0
            let a = Double(value & 0xFF) / 255.0
            self = Color(red: r, green: g, blue: b).opacity(a)
            return
        }
        return nil
    }
}


