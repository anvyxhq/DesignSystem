# ``AnvyxDesignKit``

A reactive, theme-driven SwiftUI design system: dynamic tokens, Liquid Glass, and a set of ready-made components.

## Overview

AnvyxDesignKit centers on ``AnvyxTheme`` — an `@Observable` container of design
tokens (colors, spacing, radius, typography, motion, haptics) injected through the
SwiftUI environment. Mutating a token at runtime re-renders every view that reads
it, so runtime theming and dark mode "just work" without global mutable state.

```swift
@main
struct MyApp: App {
    @State private var theme = AnvyxTheme()
    var body: some Scene {
        WindowGroup {
            RootView()
                .anvyxTheme(theme)   // inject once
        }
    }
}

struct RootView: View {
    @Environment(\.anvyxTheme) private var theme
    var body: some View {
        Text("Hello").foregroundStyle(theme.colors.accent)
    }
}
```

Brand colors that need explicit light/dark (or increased-contrast) variants use
``SwiftUI/Color/init(light:dark:highContrastLight:highContrastDark:)``.

### Component colors

Components do not read the semantic colors directly. Each reads a resolved
component token on ``ColorPalette`` — ``ColorPalette/buttonBackground``,
``ColorPalette/chipSelectedBackground``, ``ColorPalette/cardBackground``, … —
which returns the matching ``ComponentColors`` override when one is set and the
parent semantic token otherwise. Changing `accent` therefore still re-tints every
component that was not overridden, and setting one component token changes only
that component.

```swift
theme.colors.accent = .indigo                       // buttons, chips, info toasts, …
theme.colors.components.buttonBackground = .black   // primary button only
theme.colors.components.buttonBackground = nil      // inherit `accent` again
```

### Hex colors

``SwiftUI/Color/init(validatingHex:)`` parses `RGB`, `RRGGBB` and `RRGGBBAA`
(alpha last), with or without `#`, and returns `nil` for anything else.
``SwiftUI/Color/init(hex:)`` accepts the same forms but falls back to opaque
black, so prefer the validating initializer for values that come from outside
the app.

### Custom fonts

``FontRegistrar/registerFonts(named:extension:in:)`` and
``FontRegistrar/registerFonts(at:)`` register font files at runtime and return
the PostScript names read from them, ready for ``FontFamily``. Fonts that are
already registered are reported as available, not as failures.

### Motion

Pick a ``ThemeMotion`` token by how often the user sees the motion: `quick` for
repeated feedback (press, toggle, selection), `standard` for state changes inside
a screen, `emphasized` for rare moments such as a toast. Apply tokens with
``SwiftUI/View/themedAnimation(_:value:)`` and
``SwiftUI/View/themedTransition(_:)``. With Reduce Motion on, movement becomes a
fade and every token runs as `reduced`. Do not call `.animation(.spring…)` with a
literal value in components.

```swift
content
    .themedTransition(.move(edge: .top).combined(with: .opacity))
    .themedAnimation(\.emphasized, value: isPresented)
```

### Adaptive layout

Branch layout on ``LayoutWidth`` (from the horizontal size class), not on
measured screen size. Keep one screen per feature and switch only its layout
with ``AdaptiveLayout`` or ``AdaptiveStack``; state stays shared. Use
``SwiftUI/View/readableWidth(_:)`` so text and forms do not stretch across an
iPad, and `NavigationSplitView` for list–detail. Preview every screen at both
widths: `.environment(\.horizontalSizeClass, .regular)`.

## Topics

### Theming
- ``AnvyxTheme``
- ``ColorPalette``
- ``ComponentColors``
- ``SwiftUI/Color/init(validatingHex:)``
- ``SwiftUI/Color/init(hex:)``
- ``Spacing``
- ``Radius``
- ``ThemeTypography``
- ``ThemeMotion``
- ``ThemeHaptics``
- ``FontFamily``
- ``FontRegistrar``

### Motion
- ``SwiftUI/View/themedAnimation(_:value:)``
- ``SwiftUI/View/themedTransition(_:)``

### Adaptive Layout
- ``LayoutWidth``
- ``AdaptiveLayout``
- ``AdaptiveStack``
- ``SwiftUI/View/readableWidth(_:)``

### Liquid Glass
- ``AnvyxGlassContainer``

### Components
- ``AnvyxTextField``
- ``AnvyxSegmentedControl``
- ``AnvyxStepper``
- ``RatingView``
- ``SkeletonList``
- ``AnvyxIcon``
- ``Chip``
- ``Card``
- ``Badge``
- ``EmptyStateView``
- ``PagedView``

### Feedback
- ``Toast``
- ``ToastQueue``
- ``PrimaryButtonStyle``
- ``SecondaryButtonStyle``
- ``AsyncButton``

### Utilities
- ``SwiftUI/View/anvyxTimer(after:id:perform:)``
