import SwiftUI

extension Color {
    init? (hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64

        // when the RGB colors is represented with 4 bits, we scale up to 8 bits (0-255 range)
        let scaleUpToEightBit: UInt64 = 17

        switch hex.count {
        case 3: // RGB (12-bit), example: #FA0
            (alpha, red, green, blue) = (
                255,
                (int >> 8) * scaleUpToEightBit,
                (int >> 4 & 0xF) * scaleUpToEightBit,
                (int & 0xF) * scaleUpToEightBit
            )
        case 6: // RGB (24-bit), example: #FFA500
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit), example: #80FFA500
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
