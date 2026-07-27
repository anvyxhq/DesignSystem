//
//  Theme.swift
//  DesignSystem
//
//  Created by AnhPT on 02/07/2026.
//

import SwiftUI

// Design-token value types. These are carried by `AnvyxTheme` and injected via
// `@Environment(\.anvyxTheme)`. (The former global `Theme`/`AppTypography` static
// singletons were removed in the re-theme — tokens are now reactive per SE-0466,
// no global mutable state.)

public struct ColorPalette: Sendable {
    public var accent: Color
    public var background: Color
    public var surface: Color
    public var textPrimary: Color
    public var textSecondary: Color
    public var success: Color
    public var warning: Color
    public var danger: Color
    /// Hairlines between rows and sections.
    public var separator: Color

    public init(
        accent: Color = .accentColor,
        background: Color = Color(.systemBackground),
        surface: Color = Color(.secondarySystemBackground),
        textPrimary: Color = .primary,
        textSecondary: Color = .secondary,
        success: Color = .green,
        warning: Color = .orange,
        danger: Color = .red,
        separator: Color = Color(.separator)
    ) {
        self.accent = accent
        self.background = background
        self.surface = surface
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.success = success
        self.warning = warning
        self.danger = danger
        self.separator = separator
    }
}

public struct Spacing: Sendable {
    public var xs: CGFloat
    public var sm: CGFloat
    public var md: CGFloat
    public var lg: CGFloat
    public var xl: CGFloat

    public init(xs: CGFloat = 4, sm: CGFloat = 8, md: CGFloat = 16, lg: CGFloat = 24, xl: CGFloat = 32) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}

public struct Radius: Sendable {
    /// Thumbnails and small inline artwork.
    public var sm: CGFloat
    /// Icon badges and compact controls.
    public var md: CGFloat
    /// Cards, sheets and list surfaces.
    public var lg: CGFloat
    /// Hero tiles and full-width banners.
    public var xl: CGFloat

    public init(sm: CGFloat = 8, md: CGFloat = 12, lg: CGFloat = 20, xl: CGFloat = 24) {
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}

public extension Color {
    /// Create a color from a hex string such as `"#FF8800"` or `"FF8800"`.
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r, g, b, a: Double
        switch cleaned.count {
        case 6:
            r = Double((value & 0xFF0000) >> 16) / 255
            g = Double((value & 0x00FF00) >> 8) / 255
            b = Double(value & 0x0000FF) / 255
            a = 1
        case 8:
            r = Double((value & 0xFF000000) >> 24) / 255
            g = Double((value & 0x00FF0000) >> 16) / 255
            b = Double((value & 0x0000FF00) >> 8) / 255
            a = Double(value & 0x000000FF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
