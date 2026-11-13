//
//  ComponentColors.swift
//  DesignSystem
//
//  Created by AnhPT on 13/11/2026.
//

import SwiftUI

/// Optional component-level color tokens.
///
/// Every token is `nil` by default and then inherits from a semantic token of
/// ``ColorPalette`` (its *parent*, named in each property's documentation). Set
/// a token to restyle one component without touching the others:
///
/// ```swift
/// theme.colors.accent = .indigo                       // re-tints every inheriting component
/// theme.colors.components.buttonBackground = .black   // only the primary button
/// ```
///
/// Components never read these optionals directly; they read the resolved
/// accessors on ``ColorPalette`` (for example ``ColorPalette/buttonBackground``),
/// which apply the fallback.
public struct ComponentColors: Sendable {
    // MARK: Buttons

    /// Primary button fill. Inherits `accent`.
    public var buttonBackground: Color?
    /// Primary button label. Inherits `onAccent`.
    public var buttonForeground: Color?
    /// Secondary button label and border. Inherits `accent`.
    public var secondaryButtonForeground: Color?

    // MARK: Chip

    /// Unselected chip fill. Inherits `surface`.
    public var chipBackground: Color?
    /// Unselected chip label. Inherits `textPrimary`.
    public var chipForeground: Color?
    /// Selected chip fill. Inherits `accent`.
    public var chipSelectedBackground: Color?
    /// Selected chip label. Inherits `onAccent`.
    public var chipSelectedForeground: Color?

    // MARK: Card

    /// `Card` and `cardStyle()` fill. Inherits `surface`.
    public var cardBackground: Color?

    // MARK: Toast

    /// Info toast fill. Inherits `accent`.
    public var toastInfoBackground: Color?
    /// Success toast fill. Inherits `success`.
    public var toastSuccessBackground: Color?
    /// Warning toast fill. Inherits `warning`.
    public var toastWarningBackground: Color?
    /// Error toast fill. Inherits `danger`.
    public var toastErrorBackground: Color?
    /// Toast icon and message, for every style. Inherits `onAccent`.
    public var toastForeground: Color?

    // MARK: Badge

    /// Badge fill when the badge has no explicit color. Inherits `accent`.
    public var badgeBackground: Color?
    /// Badge label. Inherits `onAccent`.
    public var badgeForeground: Color?

    // MARK: Controls

    /// Text field fill. Inherits `surface`.
    public var fieldBackground: Color?
    /// Segmented control track. Inherits `surface`.
    public var segmentedBackground: Color?
    /// Segmented control selected-segment fill. Inherits `accent`.
    public var segmentedSelectedBackground: Color?
    /// Segmented control selected-segment label. Inherits `onAccent`.
    public var segmentedSelectedForeground: Color?
    /// Stepper button fill. Inherits `surface`.
    public var stepperBackground: Color?
    /// Enabled stepper button symbol. Inherits `accent`.
    public var stepperForeground: Color?

    // MARK: Indicators

    /// Filled rating star. Inherits `warning`.
    public var ratingFilled: Color?
    /// Current-page dot of `PagedView`. Inherits `accent`.
    public var pageIndicatorActive: Color?
    /// Skeleton placeholder fill. Inherits `surface`.
    public var skeletonBackground: Color?

    public init(
        buttonBackground: Color? = nil,
        buttonForeground: Color? = nil,
        secondaryButtonForeground: Color? = nil,
        chipBackground: Color? = nil,
        chipForeground: Color? = nil,
        chipSelectedBackground: Color? = nil,
        chipSelectedForeground: Color? = nil,
        cardBackground: Color? = nil,
        toastInfoBackground: Color? = nil,
        toastSuccessBackground: Color? = nil,
        toastWarningBackground: Color? = nil,
        toastErrorBackground: Color? = nil,
        toastForeground: Color? = nil,
        badgeBackground: Color? = nil,
        badgeForeground: Color? = nil,
        fieldBackground: Color? = nil,
        segmentedBackground: Color? = nil,
        segmentedSelectedBackground: Color? = nil,
        segmentedSelectedForeground: Color? = nil,
        stepperBackground: Color? = nil,
        stepperForeground: Color? = nil,
        ratingFilled: Color? = nil,
        pageIndicatorActive: Color? = nil,
        skeletonBackground: Color? = nil
    ) {
        self.buttonBackground = buttonBackground
        self.buttonForeground = buttonForeground
        self.secondaryButtonForeground = secondaryButtonForeground
        self.chipBackground = chipBackground
        self.chipForeground = chipForeground
        self.chipSelectedBackground = chipSelectedBackground
        self.chipSelectedForeground = chipSelectedForeground
        self.cardBackground = cardBackground
        self.toastInfoBackground = toastInfoBackground
        self.toastSuccessBackground = toastSuccessBackground
        self.toastWarningBackground = toastWarningBackground
        self.toastErrorBackground = toastErrorBackground
        self.toastForeground = toastForeground
        self.badgeBackground = badgeBackground
        self.badgeForeground = badgeForeground
        self.fieldBackground = fieldBackground
        self.segmentedBackground = segmentedBackground
        self.segmentedSelectedBackground = segmentedSelectedBackground
        self.segmentedSelectedForeground = segmentedSelectedForeground
        self.stepperBackground = stepperBackground
        self.stepperForeground = stepperForeground
        self.ratingFilled = ratingFilled
        self.pageIndicatorActive = pageIndicatorActive
        self.skeletonBackground = skeletonBackground
    }
}

// MARK: - Resolved accessors

/// Resolved component colors: the component token when set, otherwise its parent
/// semantic token. Components read these, never `components` directly.
public extension ColorPalette {
    var buttonBackground: Color { components.buttonBackground ?? accent }
    var buttonForeground: Color { components.buttonForeground ?? onAccent }
    var secondaryButtonForeground: Color { components.secondaryButtonForeground ?? accent }

    var chipBackground: Color { components.chipBackground ?? surface }
    var chipForeground: Color { components.chipForeground ?? textPrimary }
    var chipSelectedBackground: Color { components.chipSelectedBackground ?? accent }
    var chipSelectedForeground: Color { components.chipSelectedForeground ?? onAccent }

    var cardBackground: Color { components.cardBackground ?? surface }

    var toastInfoBackground: Color { components.toastInfoBackground ?? accent }
    var toastSuccessBackground: Color { components.toastSuccessBackground ?? success }
    var toastWarningBackground: Color { components.toastWarningBackground ?? warning }
    var toastErrorBackground: Color { components.toastErrorBackground ?? danger }
    var toastForeground: Color { components.toastForeground ?? onAccent }

    /// The fill for a toast of `style`.
    func toastBackground(for style: Toast.Style) -> Color {
        switch style {
        case .info:    return toastInfoBackground
        case .success: return toastSuccessBackground
        case .warning: return toastWarningBackground
        case .error:   return toastErrorBackground
        }
    }

    var badgeBackground: Color { components.badgeBackground ?? accent }
    var badgeForeground: Color { components.badgeForeground ?? onAccent }

    var fieldBackground: Color { components.fieldBackground ?? surface }
    var segmentedBackground: Color { components.segmentedBackground ?? surface }
    var segmentedSelectedBackground: Color { components.segmentedSelectedBackground ?? accent }
    var segmentedSelectedForeground: Color { components.segmentedSelectedForeground ?? onAccent }
    var stepperBackground: Color { components.stepperBackground ?? surface }
    var stepperForeground: Color { components.stepperForeground ?? accent }

    var ratingFilled: Color { components.ratingFilled ?? warning }
    var pageIndicatorActive: Color { components.pageIndicatorActive ?? accent }
    var skeletonBackground: Color { components.skeletonBackground ?? surface }
}
