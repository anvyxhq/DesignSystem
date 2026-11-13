# DesignSystem

A SwiftUI design system: theme tokens and reusable components to keep apps visually consistent.

[![Swift](https://img.shields.io/badge/Swift-6.2+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

- **`AnvyxTheme`** — reactive color, spacing, radius, typography, motion and haptics tokens injected through the SwiftUI environment. Rebrand in one line.
- **Typography** — Dynamic-Type-aware font tokens with a custom-font family and runtime `FontRegistrar`.
- **Motion and layout** — motion tokens that honour Reduce Motion, plus `AdaptiveLayout`, `AdaptiveStack` and `.readableWidth()` for compact and regular widths.
- **Button styles** — `.primary` and `.secondary`.
- **Components** — `Card`, `LoadingOverlay`, `Toast`, `AsyncButton`, `EmptyStateView` (built on `ContentUnavailableView`), `Badge`, `Chip`, `PagedView`, `.cardStyle()`, and a `.shimmering()` skeleton modifier.
- **`Color(hex:)`** and **`Color(validatingHex:)`** — hex string initializers (RGB / RGBA); the validating one fails on malformed input.

> Built for iOS 17+ to use the latest SwiftUI APIs.

## Installation

```swift
.package(url: "https://github.com/anvyxhq/DesignSystem.git", branch: "main")
```

> The latest tagged release predates the current `Anvyx*` module names, so depend on `main` until the next tagged release.

## Usage

```swift
import AnvyxDesignKit

// Inject the theme once near the app root
@State private var theme = AnvyxTheme(colors: ColorPalette(accent: Color(hex: "#5B5BFF")))

RootView().anvyxTheme(theme)

// Read tokens in any view
@Environment(\.anvyxTheme) private var theme
Text("Title").font(theme.typography.title).foregroundStyle(theme.colors.accent)

// Buttons
Button("Continue") { }.buttonStyle(.primary)

// Loading overlay
content.loadingOverlay(isPresented: isLoading, message: "Processing…")

// Toast
content.toast($toast)   // @State private var toast: Toast?

// Motion that honours Reduce Motion
content.themedAnimation(\.standard, value: isExpanded)

// Layout that adapts to compact and regular widths
AdaptiveStack { summary; details }

// Custom fonts
FontRegistrar.register(["Inter-Regular", "Inter-Bold"])
theme.typography.family = FontFamily(regular: "Inter-Regular", medium: "Inter-Medium",
                                     semibold: "Inter-SemiBold", bold: "Inter-Bold")
```

## Requirements

- iOS 17+ · Swift 6.2+ (Xcode 26+)

## License

MIT
