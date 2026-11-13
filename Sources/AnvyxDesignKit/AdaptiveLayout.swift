//
//  AdaptiveLayout.swift
//  DesignSystem
//
//  Created by AnhPT on 13/11/2026.
//

import SwiftUI

/// The width class a screen lays itself out for.
///
/// Derived from the horizontal size class, which SwiftUI already keeps current
/// for rotation, iPad Split View and Stage Manager. Branch on this instead of
/// measuring the screen with `GeometryReader` or `UIScreen.main.bounds`.
public enum LayoutWidth: Sendable, Equatable {
    /// iPhone portrait, iPhone landscape (most models), narrow iPad split.
    case compact
    /// iPad full screen, wide iPad split, large iPhone landscape.
    case regular

    public init(_ sizeClass: UserInterfaceSizeClass?) {
        self = sizeClass == .regular ? .regular : .compact
    }
}

/// Shows `compact` or `regular` content for the current width class.
///
/// Keep one screen per feature and branch only the layout, so state and logic
/// stay shared:
///
/// ```swift
/// AdaptiveLayout {
///     ProductList(items: items)                 // single column
/// } regular: {
///     ProductGrid(items: items, columns: 3)     // grid on iPad
/// }
/// ```
///
/// For list–detail navigation, use `NavigationSplitView`: it already collapses
/// to a stack on compact widths.
public struct AdaptiveLayout<Compact: View, Regular: View>: View {
    private let compact: Compact
    private let regular: Regular
    @Environment(\.horizontalSizeClass) private var sizeClass

    public init(
        @ViewBuilder compact: () -> Compact,
        @ViewBuilder regular: () -> Regular
    ) {
        self.compact = compact()
        self.regular = regular()
    }

    public var body: some View {
        switch LayoutWidth(sizeClass) {
        case .compact: compact
        case .regular: regular
        }
    }
}

/// A stack that is vertical on compact widths and horizontal on regular widths.
///
/// Uses `AnyLayout`, so child views keep their identity and state when the
/// width class changes (for example when the user rotates an iPad or resizes a
/// split).
public struct AdaptiveStack<Content: View>: View {
    private let alignment: Alignment
    private let spacing: CGFloat?
    private let content: Content
    @Environment(\.horizontalSizeClass) private var sizeClass

    public init(
        alignment: Alignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        let layout = switch LayoutWidth(sizeClass) {
        case .compact: AnyLayout(VStackLayout(alignment: alignment.horizontal, spacing: spacing))
        case .regular: AnyLayout(HStackLayout(alignment: alignment.vertical, spacing: spacing))
        }
        layout { content }
    }
}

public extension View {
    /// Limit content to a comfortable reading width and center it, so text and
    /// forms do not stretch across a full iPad screen. Has no effect on iPhone
    /// portrait, where the screen is narrower than `maxWidth`.
    func readableWidth(_ maxWidth: CGFloat = 672) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}
