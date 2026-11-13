//
//  Typography.swift
//  DesignSystem
//
//  Created by AnhPT on 02/07/2026.
//

import SwiftUI
import CoreText

/// Names of a custom font's weights. Leave `AppTypography.family` as `nil` to use
/// the system font.
public struct FontFamily: Sendable {
    public var regular: String
    public var medium: String
    public var semibold: String
    public var bold: String

    public init(regular: String, medium: String, semibold: String, bold: String) {
        self.regular = regular
        self.medium = medium
        self.semibold = semibold
        self.bold = bold
    }

    func postScriptName(for weight: Font.Weight) -> String {
        switch weight {
        case .bold, .heavy, .black:        return bold
        case .semibold:                    return semibold
        case .medium:                      return medium
        default:                            return regular
        }
    }
}

// Typography tokens now live on `ThemeTypography` (see AnvyxTheme.swift), read via
// `@Environment(\.anvyxTheme).typography`. The former global `AppTypography` and
// `Font.app(...)` static API was removed in the re-theme.

/// Registers custom font files bundled with the app/package at runtime, so they
/// don't need to be listed in Info.plist (`UIAppFonts`).
///
/// ```swift
/// // PostScript names are read from the files, so they need not be known up front.
/// let names = FontRegistrar.registerFonts(named: ["Inter-Regular", "Inter-Bold"], in: .module)
///
/// // Or, when only success matters:
/// FontRegistrar.register(["Inter-Regular", "Inter-Bold"], in: .module)
/// theme.typography.family = FontFamily(regular: "Inter-Regular", medium: "Inter-Medium",
///                                      semibold: "Inter-SemiBold", bold: "Inter-Bold")
/// ```
public enum FontRegistrar {
    /// Registers the named font files from `bundle`.
    ///
    /// - Returns: `true` only when every file was found and newly registered.
    ///   Use ``registerFonts(named:extension:in:)`` to learn which fonts are
    ///   usable and to treat already-registered fonts as success.
    @discardableResult
    public static func register(_ names: [String], extension ext: String = "ttf", in bundle: Bundle = .main) -> Bool {
        var allOK = true
        for name in names {
            guard let url = bundle.url(forResource: name, withExtension: ext) else { allOK = false; continue }
            if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) {
                allOK = false
            }
        }
        return allOK
    }

    /// Registers the font files at `urls` and returns the PostScript names they
    /// provide, read from the files themselves.
    ///
    /// A file whose fonts are already registered is not an error: its names are
    /// still returned. A file that is missing, is not a font, or fails to
    /// register for another reason is skipped and contributes no names.
    ///
    /// - Returns: PostScript names usable with `Font.custom(_:size:)` or
    ///   ``FontFamily``, in file order, without duplicates. A collection file
    ///   (`.ttc`) contributes one name per face.
    @discardableResult
    public static func registerFonts(at urls: [URL]) -> [String] {
        var names: [String] = []
        for url in urls {
            let fileNames = postScriptNames(at: url)
            guard !fileNames.isEmpty, registerFile(at: url) else { continue }
            for name in fileNames where !names.contains(name) {
                names.append(name)
            }
        }
        return names
    }

    /// Registers the named font files from `bundle` and returns the PostScript
    /// names they provide. Names with no matching file are skipped.
    ///
    /// See ``registerFonts(at:)`` for how failures and already-registered fonts
    /// are handled.
    @discardableResult
    public static func registerFonts(
        named names: [String],
        extension ext: String = "ttf",
        in bundle: Bundle = .main
    ) -> [String] {
        registerFonts(at: names.compactMap { bundle.url(forResource: $0, withExtension: ext) })
    }

    /// The PostScript names of the fonts in the file at `url`, without
    /// registering anything. Empty when the file is missing or not a font.
    public static func postScriptNames(at url: URL) -> [String] {
        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor] else {
            return []
        }
        return descriptors.compactMap {
            CTFontDescriptorCopyAttribute($0, kCTFontNameAttribute) as? String
        }
    }

    /// `true` when the file is registered after the call, whether by this call
    /// or by an earlier one.
    private static func registerFile(at url: URL) -> Bool {
        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) { return true }
        guard let cfError = error?.takeRetainedValue() else { return false }
        let alreadyRegistered: Set<CFIndex> = [
            CTFontManagerError.alreadyRegistered.rawValue,
            CTFontManagerError.duplicatedName.rawValue,
        ]
        return CFErrorGetDomain(cfError) == kCTFontManagerErrorDomain
            && alreadyRegistered.contains(CFErrorGetCode(cfError))
    }
}
