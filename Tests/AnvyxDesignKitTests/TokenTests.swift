//
//  TokenTests.swift
//  DesignSystem
//
//  Created by AnhPT on 13/11/2026.
//

import XCTest
import SwiftUI
import CoreText
@testable import AnvyxDesignKit

final class TokenTests: XCTestCase {
    // MARK: - Hex colors

    private func assertHex(
        _ hex: String,
        _ expected: (Double, Double, Double, Double),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let c = Color.hexComponents(hex) else {
            return XCTFail("\(hex) should parse", file: file, line: line)
        }
        XCTAssertEqual(c.red, expected.0 / 255, accuracy: 1e-9, file: file, line: line)
        XCTAssertEqual(c.green, expected.1 / 255, accuracy: 1e-9, file: file, line: line)
        XCTAssertEqual(c.blue, expected.2 / 255, accuracy: 1e-9, file: file, line: line)
        XCTAssertEqual(c.alpha, expected.3 / 255, accuracy: 1e-9, file: file, line: line)
    }

    func testValidHexParsesToComponents() {
        assertHex("#FF8800", (255, 136, 0, 255))
        assertHex("FF8800", (255, 136, 0, 255))
        assertHex("ff8800", (255, 136, 0, 255))
        assertHex("#00FF0080", (0, 255, 0, 128))   // RRGGBBAA: alpha is last
        assertHex("12345678", (0x12, 0x34, 0x56, 0x78))
        assertHex("#F80", (255, 136, 0, 255))      // shorthand doubles each digit
        assertHex("000000", (0, 0, 0, 255))
    }

    func testValidatingHexAcceptsValidInput() {
        for hex in ["#FF8800", "FF8800", "#00FF0080", "00ff0080", "#abc", "ABC"] {
            XCTAssertNotNil(Color(validatingHex: hex), hex)
        }
        XCTAssertEqual(Color(validatingHex: "#FF8800"), Color(.sRGB, red: 1, green: 136 / 255, blue: 0, opacity: 1))
    }

    func testValidatingHexRejectsInvalidInput() {
        let invalid = [
            "", "#", "bogus", "GGGGGG", "#FF88ZZ",      // non-hex characters
            "F", "FF", "FFFF", "FFFFF", "FFFFFFF", "FFFFFFFFF", // wrong lengths
            "##FF8800", "FF8800#", " FF8800", "FF8800 ", "FF 880", // stray characters
            "+F8800", "-F8800", "0xFF88", "ＦＦ８８００",          // sign, prefix, full-width digits
        ]
        for hex in invalid {
            XCTAssertNil(Color(validatingHex: hex), "\"\(hex)\" should be rejected")
        }
    }

    func testHexFallsBackToOpaqueBlackForInvalidInput() {
        let black = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 1)
        XCTAssertEqual(Color(hex: "bogus"), black)
        XCTAssertEqual(Color(hex: ""), black)
        XCTAssertEqual(Color(hex: "#FF8800"), Color(validatingHex: "FF8800"))
        XCTAssertEqual(Color(hex: "00FF0080"), Color(validatingHex: "#00FF0080"))
    }

    // MARK: - Component colors

    func testComponentColorsDefaultToParentToken() {
        let palette = ColorPalette(
            accent: .purple, surface: .gray, textPrimary: .black,
            success: .green, warning: .orange, danger: .red, onAccent: .yellow
        )
        XCTAssertEqual(palette.buttonBackground, .purple)
        XCTAssertEqual(palette.buttonForeground, .yellow)
        XCTAssertEqual(palette.secondaryButtonForeground, .purple)
        XCTAssertEqual(palette.chipBackground, .gray)
        XCTAssertEqual(palette.chipForeground, .black)
        XCTAssertEqual(palette.chipSelectedBackground, .purple)
        XCTAssertEqual(palette.chipSelectedForeground, .yellow)
        XCTAssertEqual(palette.cardBackground, .gray)
        XCTAssertEqual(palette.toastInfoBackground, .purple)
        XCTAssertEqual(palette.toastSuccessBackground, .green)
        XCTAssertEqual(palette.toastWarningBackground, .orange)
        XCTAssertEqual(palette.toastErrorBackground, .red)
        XCTAssertEqual(palette.toastForeground, .yellow)
        XCTAssertEqual(palette.badgeBackground, .purple)
        XCTAssertEqual(palette.badgeForeground, .yellow)
        XCTAssertEqual(palette.fieldBackground, .gray)
        XCTAssertEqual(palette.segmentedBackground, .gray)
        XCTAssertEqual(palette.segmentedSelectedBackground, .purple)
        XCTAssertEqual(palette.segmentedSelectedForeground, .yellow)
        XCTAssertEqual(palette.stepperBackground, .gray)
        XCTAssertEqual(palette.stepperForeground, .purple)
        XCTAssertEqual(palette.ratingFilled, .orange)
        XCTAssertEqual(palette.pageIndicatorActive, .purple)
        XCTAssertEqual(palette.skeletonBackground, .gray)

        XCTAssertEqual(palette.toastBackground(for: .info), palette.toastInfoBackground)
        XCTAssertEqual(palette.toastBackground(for: .success), palette.toastSuccessBackground)
        XCTAssertEqual(palette.toastBackground(for: .warning), palette.toastWarningBackground)
        XCTAssertEqual(palette.toastBackground(for: .error), palette.toastErrorBackground)
    }

    func testDefaultPaletteKeepsOnAccentWhite() {
        XCTAssertEqual(ColorPalette().onAccent, .white)
        XCTAssertEqual(ColorPalette().buttonForeground, .white)
    }

    func testComponentColorOverrideWinsAndTouchesOnlyThatComponent() {
        var palette = ColorPalette(accent: .purple, surface: .gray)
        palette.components.buttonBackground = .black
        palette.components.cardBackground = .mint

        XCTAssertEqual(palette.buttonBackground, .black)
        XCTAssertEqual(palette.cardBackground, .mint)
        // Siblings that share the same parent are untouched.
        XCTAssertEqual(palette.chipSelectedBackground, .purple)
        XCTAssertEqual(palette.toastInfoBackground, .purple)
        XCTAssertEqual(palette.secondaryButtonForeground, .purple)
        XCTAssertEqual(palette.chipBackground, .gray)
        XCTAssertEqual(palette.fieldBackground, .gray)
        // The parents themselves do not change.
        XCTAssertEqual(palette.accent, .purple)
        XCTAssertEqual(palette.surface, .gray)

        palette.components.buttonBackground = nil
        XCTAssertEqual(palette.buttonBackground, .purple) // inherits again
    }

    func testChangingParentAffectsOnlyNonOverriddenTokens() {
        var palette = ColorPalette(accent: .purple)
        palette.components.chipSelectedBackground = .black

        palette.accent = .teal

        XCTAssertEqual(palette.chipSelectedBackground, .black) // overridden: unchanged
        XCTAssertEqual(palette.buttonBackground, .teal)
        XCTAssertEqual(palette.toastInfoBackground, .teal)
        XCTAssertEqual(palette.segmentedSelectedBackground, .teal)
        XCTAssertEqual(palette.stepperForeground, .teal)
    }

    @MainActor
    func testThemeExposesComponentColors() {
        let theme = AnvyxTheme(colors: ColorPalette(components: ComponentColors(toastInfoBackground: .indigo)))
        theme.colors.accent = .pink
        XCTAssertEqual(theme.colors.toastInfoBackground, .indigo)
        XCTAssertEqual(theme.colors.buttonBackground, .pink)
    }

    // MARK: - Font registration

    /// A font file that ships with the OS, so the test needs no bundled fixture.
    private func systemFontFileURL() throws -> URL {
        let font = CTFontCreateWithName("Courier" as CFString, 12, nil)
        return try XCTUnwrap(CTFontCopyAttribute(font, kCTFontURLAttribute) as? URL)
    }

    func testRegisterFontsReturnsPostScriptNamesAndToleratesRepeats() throws {
        // Register a private copy so the result does not depend on the system
        // having already activated the original file.
        let copy = FileManager.default.temporaryDirectory
            .appendingPathComponent("AnvyxDesignKitTests-\(UUID().uuidString)")
            .appendingPathExtension(try systemFontFileURL().pathExtension)
        try FileManager.default.copyItem(at: try systemFontFileURL(), to: copy)
        defer {
            CTFontManagerUnregisterFontsForURL(copy as CFURL, .process, nil)
            try? FileManager.default.removeItem(at: copy)
        }

        let expected = FontRegistrar.postScriptNames(at: copy)
        XCTAssertFalse(expected.isEmpty)

        let first = FontRegistrar.registerFonts(at: [copy])
        XCTAssertEqual(first, expected)

        // Already registered: still reported, and listing a file twice does not
        // duplicate its names.
        let second = FontRegistrar.registerFonts(at: [copy, copy])
        XCTAssertEqual(second, expected)
    }

    func testRegisterFontsSkipsMissingAndNonFontFiles() throws {
        let missing = URL(fileURLWithPath: "/nonexistent/Missing-Regular.ttf")
        let notAFont = FileManager.default.temporaryDirectory
            .appendingPathComponent("AnvyxDesignKitTests-\(UUID().uuidString).ttf")
        try Data("not a font".utf8).write(to: notAFont)
        defer { try? FileManager.default.removeItem(at: notAFont) }

        XCTAssertEqual(FontRegistrar.registerFonts(at: [missing, notAFont]), [])
        XCTAssertEqual(FontRegistrar.postScriptNames(at: missing), [])
        XCTAssertEqual(FontRegistrar.registerFonts(named: ["Missing-Regular"], in: .main), [])
        XCTAssertEqual(FontRegistrar.registerFonts(at: []), [])
    }

    // MARK: - Default token sanity

    private func assertStrictlyIncreasing(
        _ values: [CGFloat], _ group: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        for (lower, upper) in zip(values, values.dropFirst()) {
            XCTAssertLessThan(lower, upper, "\(group) scale must be strictly increasing: \(values)", file: file, line: line)
        }
    }

    /// The stored properties of a token group, so a newly added token is covered
    /// without editing the test.
    private func storedValues<T>(of group: Any, as type: T.Type) -> [String: T?] {
        var result: [String: T?] = [:]
        for child in Mirror(reflecting: group).children {
            result[child.label ?? "?"] = child.value as? T
        }
        return result
    }

    @MainActor
    func testEveryTokenGroupHasSaneDefaults() {
        // Spacing: positive, strictly increasing xs < sm < md < lg < xl.
        let spacing = Spacing()
        XCTAssertGreaterThan(spacing.xs, 0)
        assertStrictlyIncreasing([spacing.xs, spacing.sm, spacing.md, spacing.lg, spacing.xl], "Spacing")
        XCTAssertEqual(Mirror(reflecting: spacing).children.count, 5, "New spacing token: add it to the scale above")

        // Radius: non-negative, strictly increasing sm < md < lg < xl.
        let radius = Radius()
        XCTAssertGreaterThanOrEqual(radius.sm, 0)
        assertStrictlyIncreasing([radius.sm, radius.md, radius.lg, radius.xl], "Radius")
        XCTAssertEqual(Mirror(reflecting: radius).children.count, 4, "New radius token: add it to the scale above")

        // Motion: every stored token is an Animation, and the feedback token is
        // not the same curve as the attention token.
        let motion = ThemeMotion()
        let animations = storedValues(of: motion, as: Animation.self)
        XCTAssertEqual(Set(animations.keys), ["quick", "standard", "emphasized", "reduced"])
        for (name, animation) in animations {
            XCTAssertNotNil(animation, "motion.\(name) must be an Animation")
        }
        XCTAssertNotEqual(motion.quick, motion.emphasized)
        XCTAssertNotEqual(motion.quick, motion.standard)

        // Colors: every semantic token is set; every component token starts unset
        // so that it inherits.
        let palette = ColorPalette()
        let semantic = storedValues(of: palette, as: Color.self).filter { $0.key != "components" }
        XCTAssertEqual(semantic.count, 10)
        for (name, color) in semantic {
            XCTAssertNotNil(color, "colors.\(name) must be a Color")
        }
        let componentTokens = Mirror(reflecting: palette.components).children
        XCTAssertFalse(componentTokens.isEmpty)
        for token in componentTokens {
            let value = Mirror(reflecting: token.value)
            XCTAssertEqual(value.displayStyle, .optional, "components.\(token.label ?? "?") must be optional")
            XCTAssertTrue(value.children.isEmpty, "components.\(token.label ?? "?") must default to nil")
        }

        // Typography, haptics, icons.
        let typography = ThemeTypography()
        XCTAssertNil(typography.family)
        XCTAssertEqual(typography.design, .default)
        XCTAssertTrue(ThemeHaptics().isEnabled)
        assertStrictlyIncreasing(
            [AnvyxIcon.Size.small.points, AnvyxIcon.Size.medium.points, AnvyxIcon.Size.large.points], "Icon size"
        )

        // The theme is built from exactly these defaults.
        let theme = AnvyxTheme()
        XCTAssertEqual(theme.spacing.md, spacing.md)
        XCTAssertEqual(theme.radius.md, radius.md)
        XCTAssertEqual(theme.motion.standard, motion.standard)
        XCTAssertEqual(theme.colors.buttonBackground, theme.colors.accent)
    }
}
