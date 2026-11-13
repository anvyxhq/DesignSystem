# Changelog

All notable changes to this package are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the package follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Breaking

- **Breaking:** Products and modules were renamed to `Anvyx*` (`AnvyxDesignKit`) and the package now requires Swift 6.2 (Xcode 26). Update `.product(name:)` entries and `import` statements.
- **Breaking:** `Color(hex:)` returns opaque black for any malformed string, including input the old parser read partially (for example `"12345G"`). Use `Color(validatingHex:)` to detect invalid input.

### Added

- Component color tokens, validating hex init, font registration by file
- Reduce-Motion-aware motion tokens and adaptive layout
- AnvyxWebView wrapper over SwiftUI WebView/WebPage (iOS 26)
- Themed component set — text field, segmented, stepper, toast queue, skeleton, rating, icon (re-theme phase 4)
- Liquid Glass wrappers with pre-26 fallback (re-theme phase 3)
- Theme foundation — @Observable AnvyxTheme + environment (re-theme phase 1)

### Changed

- Unify on AnvyxTheme and inject the Snapfolio palette at the root
- Liquid Glass smoke test + confirm wrapper coverage (P0)
- Make Liquid Glass wrappers @available(iOS 26), drop if/else
- Extract reusable View.anvyxTimer(after:id:perform:)
- Migrate components to @Environment theme, remove global static (re-theme phase 2)
- Rename module(s) -> Anvyx* (naming convention)

### Fixed

- Fix LiquidGlassTests isolation (@MainActor)

## [2.1.0] - 2026-07-02

### Added

- PagedView, Chip, cardStyle() components

## [2.0.2] - 2026-07-02

_No notable changes._

## [2.0.1] - 2026-07-02

_No notable changes._

## [2.0.0] - 2026-07-02

_No notable changes._

## [1.2.0] - 2026-07-01

### Added

- Adopt iOS 17 + Observation (@Observable); DesignSystem adds Typography/fonts

## [1.1.0] - 2026-07-01

### Added

- Add AsyncButton, Shimmer/skeleton, EmptyStateView, Badge

## [1.0.0] - 2026-07-01

### Changed

- Initial release (SwiftUI/async-await iOS base)
