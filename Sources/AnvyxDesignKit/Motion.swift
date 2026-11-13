//
//  Motion.swift
//  DesignSystem
//
//  Created by AnhPT on 13/11/2026.
//

import SwiftUI

public extension ThemeMotion {
    /// The animation to run for `animation`: `reduced` while Reduce Motion is on.
    func animation(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? reduced : animation
    }

    /// The transition to run: a plain fade while Reduce Motion is on, so nothing
    /// moves, slides or scales on screen.
    func transition(_ transition: AnyTransition, reduceMotion: Bool) -> AnyTransition {
        reduceMotion ? .opacity : transition
    }
}

private struct ThemedAnimation<Value: Equatable>: ViewModifier {
    let token: KeyPath<ThemeMotion, Animation>
    let value: Value
    @Environment(\.anvyxTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.animation(
            theme.motion.animation(theme.motion[keyPath: token], reduceMotion: reduceMotion),
            value: value
        )
    }
}

private struct ThemedTransition: ViewModifier {
    let transition: AnyTransition
    @Environment(\.anvyxTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.transition(theme.motion.transition(transition, reduceMotion: reduceMotion))
    }
}

public extension View {
    /// Animate changes to `value` with a motion token from the current theme.
    ///
    /// ```swift
    /// content.themedAnimation(\.standard, value: isExpanded)
    /// ```
    func themedAnimation<Value: Equatable>(
        _ token: KeyPath<ThemeMotion, Animation>,
        value: Value
    ) -> some View {
        modifier(ThemedAnimation(token: token, value: value))
    }

    /// Apply `transition`, replaced by a fade while Reduce Motion is on.
    func themedTransition(_ transition: AnyTransition) -> some View {
        modifier(ThemedTransition(transition: transition))
    }
}
