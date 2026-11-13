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
    /// Labels and icons drawn on top of an `accent`, `success`, `warning` or
    /// `danger` fill (filled buttons, selected chips, toasts, badges).
    public var onAccent: Color
    /// Optional per-component overrides. Unset tokens inherit from the semantic
    /// colors above; read them through the resolved accessors such as
    /// ``buttonBackground`` or ``cardBackground``.
    public var components: ComponentColors

    public init(
        accent: Color = .accentColor,
        background: Color = Color(.systemBackground),
        surface: Color = Color(.secondarySystemBackground),
        textPrimary: Color = .primary,
        textSecondary: Color = .secondary,
        success: Color = .green,
        warning: Color = .orange,
        danger: Color = .red,
        separator: Color = Color(.separator),
        onAccent: Color = .white,
        components: ComponentColors = ComponentColors()
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
        self.onAccent = onAccent
        self.components = components
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
    /// Create a color from a hex string, or `nil` when the string is not a valid
    /// hex color.
    ///
    /// Accepted forms, each with or without a leading `#` (case-insensitive):
    /// - `RGB` — shorthand, each digit doubled (`"F80"` is `"FF8800"`), opaque.
    /// - `RRGGBB` — opaque.
    /// - `RRGGBBAA` — alpha is the **last** byte (RGBA order, as in CSS).
    ///
    /// Any other length, any non-hex character, or surrounding whitespace makes
    /// the initializer fail. Components are interpreted in sRGB.
    init?(validatingHex hex: String) {
        guard let c = Self.hexComponents(hex) else { return nil }
        self.init(.sRGB, red: c.red, green: c.green, blue: c.blue, opacity: c.alpha)
    }

    /// Create a color from a hex string such as `"#FF8800"` or `"FF8800"`.
    ///
    /// Accepts the same forms as ``init(validatingHex:)``; an eight-digit value
    /// is read as `RRGGBBAA` (alpha last). Invalid input does not fail: it
    /// falls back to **opaque black**. Use ``init(validatingHex:)`` when the
    /// string comes from outside the app and a silent fallback is not wanted.
    init(hex: String) {
        self = Color(validatingHex: hex) ?? Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 1)
    }

    /// Parses a hex color string into sRGB components in `0...1`.
    internal static func hexComponents(
        _ hex: String
    ) -> (red: Double, green: Double, blue: Double, alpha: Double)? {
        var digits = Substring(hex)
        if digits.hasPrefix("#") { digits.removeFirst() }

        var nibbles: [UInt8] = []
        nibbles.reserveCapacity(8)
        for byte in digits.utf8 {
            switch byte {
            case UInt8(ascii: "0")...UInt8(ascii: "9"): nibbles.append(byte - UInt8(ascii: "0"))
            case UInt8(ascii: "a")...UInt8(ascii: "f"): nibbles.append(byte - UInt8(ascii: "a") + 10)
            case UInt8(ascii: "A")...UInt8(ascii: "F"): nibbles.append(byte - UInt8(ascii: "A") + 10)
            default: return nil
            }
        }

        func channel(_ high: UInt8, _ low: UInt8) -> Double {
            Double(high << 4 | low) / 255
        }
        let n = nibbles
        switch n.count {
        case 3: return (channel(n[0], n[0]), channel(n[1], n[1]), channel(n[2], n[2]), 1)
        case 6: return (channel(n[0], n[1]), channel(n[2], n[3]), channel(n[4], n[5]), 1)
        case 8: return (channel(n[0], n[1]), channel(n[2], n[3]), channel(n[4], n[5]), channel(n[6], n[7]))
        default: return nil
        }
    }
}
