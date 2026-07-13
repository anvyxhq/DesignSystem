//
//  ThemeObservationTests.swift
//  DesignSystem
//
//  Created by AnhPT on 13/07/2026.
//

import XCTest
import SwiftUI
import Observation
@testable import AnvyxDesignKit

/// `withObservationTracking`'s `onChange` is `@Sendable` — box the flag.
private final class Flag: @unchecked Sendable { var raised = false }

@MainActor
final class ThemeObservationTests: XCTestCase {

    /// The core acceptance criterion of the re-theme: mutating a token at runtime
    /// notifies observers, so every view reading `@Environment(\.anvyxTheme)`
    /// re-renders. Verified via the Observation framework SwiftUI uses.
    func testMutatingColorTokenTriggersObservation() {
        let theme = AnvyxTheme()
        let flag = Flag()
        withObservationTracking {
            _ = theme.colors.accent
        } onChange: {
            flag.raised = true
        }

        theme.colors.accent = .purple
        XCTAssertTrue(flag.raised, "changing a color token must notify observers")
    }

    func testMutatingSpacingTokenTriggersObservation() {
        let theme = AnvyxTheme()
        let flag = Flag()
        withObservationTracking {
            _ = theme.spacing.md
        } onChange: {
            flag.raised = true
        }

        theme.spacing.md = 40
        XCTAssertTrue(flag.raised)
    }

    /// No global mutable state: separate themes are independent instances.
    func testThemesAreIndependentInstances() {
        let a = AnvyxTheme()
        let b = AnvyxTheme()
        a.colors.accent = .red
        b.colors.accent = .blue
        XCTAssertNotEqual(a.colors.accent, b.colors.accent)
        XCTAssertNotIdentical(a, b)
    }

    /// Brand tint override flows through the palette.
    func testAccentTintOverride() {
        let theme = AnvyxTheme(colors: ColorPalette(accent: Color(hex: "#FF8800")))
        XCTAssertEqual(theme.colors.accent, Color(hex: "#FF8800"))
    }
}
