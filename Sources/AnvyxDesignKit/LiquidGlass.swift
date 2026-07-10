//
//  LiquidGlass.swift
//  DesignSystem
//
//  Created by AnhPT on 10/07/2026.
//
//  Thin Anvyx wrappers over SwiftUI's iOS 26 Liquid Glass APIs, each with a
//  graceful pre-26 fallback (material) so call sites stay on the iOS 17 floor.
//

import SwiftUI

public extension View {
    /// Apply a Liquid Glass effect clipped to `shape` (iOS 26+); falls back to an
    /// ultra-thin material background on earlier systems.
    @ViewBuilder
    func anvyxGlass(in shape: some Shape = Capsule()) -> some View {
        if #available(iOS 26, *) {
            glassEffect(.regular, in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
        }
    }

    /// Apply an interactive (tappable) Liquid Glass effect (iOS 26+); falls back
    /// to a material background pre-26.
    @ViewBuilder
    func anvyxInteractiveGlass(in shape: some Shape = Capsule()) -> some View {
        if #available(iOS 26, *) {
            glassEffect(.regular.interactive(), in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
        }
    }

    /// Use the `.glass` button style on iOS 26+, else `.bordered`.
    @ViewBuilder
    func anvyxGlassButtonStyle() -> some View {
        if #available(iOS 26, *) {
            buttonStyle(.glass)
        } else {
            buttonStyle(.bordered)
        }
    }

    /// Use the `.glassProminent` button style on iOS 26+, else `.borderedProminent`.
    @ViewBuilder
    func anvyxProminentGlassButtonStyle() -> some View {
        if #available(iOS 26, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
        }
    }

    /// Extend the view's background content under adjacent bars / safe areas with
    /// a soft blur (iOS 26+); no-op pre-26.
    @ViewBuilder
    func anvyxBackgroundExtensionEffect() -> some View {
        if #available(iOS 26, *) {
            backgroundExtensionEffect()
        } else {
            self
        }
    }

    /// Associate this glass shape with `id` inside an `AnvyxGlassContainer` so it
    /// can morph/blend with siblings sharing the namespace (iOS 26+); no-op pre-26.
    @ViewBuilder
    func anvyxGlassEffectID(_ id: some Hashable & Sendable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 26, *) {
            glassEffectID(id, in: namespace)
        } else {
            self
        }
    }
}

/// Groups Liquid Glass shapes so they blend/morph together (iOS 26+). Pre-26 it
/// simply renders its content, so it is safe to use unconditionally.
public struct AnvyxGlassContainer<Content: View>: View {
    private let spacing: CGFloat
    @ViewBuilder private let content: () -> Content

    public init(spacing: CGFloat = 20, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: spacing, content: content)
        } else {
            content()
        }
    }
}
