//
//  WebView.swift
//  AnvyxDesignKit
//
//  Created by AnhPT on 10/07/2026.
//
//  A thin wrapper over SwiftUI's native `WebView`/`WebPage` (iOS 26). Marked
//  `@available(iOS 26, *)` so it stays branch-free — a caller supporting older
//  systems gates once at the call site.
//

import SwiftUI
import WebKit

/// A SwiftUI web view that loads a URL and exposes its live navigation state.
///
/// ```swift
/// if #available(iOS 26, *) {
///     AnvyxWebView(url: URL(string: "https://apple.com")!)
/// }
/// ```
///
/// Pass a shared ``page`` when you need to observe `title`/`url`/`isLoading` or
/// drive navigation (`reload`, `stopLoading`) from outside.
@available(iOS 26, *)
public struct AnvyxWebView: View {
    @State private var ownedPage = WebPage()
    private let page: WebPage?
    private let url: URL

    /// Load `url` in a self-managed page.
    public init(url: URL) {
        self.url = url
        self.page = nil
    }

    /// Load `url` in a caller-provided `page` (so its state can be observed).
    public init(url: URL, page: WebPage) {
        self.url = url
        self.page = page
    }

    private var activePage: WebPage { page ?? ownedPage }

    public var body: some View {
        WebView(activePage)
            .onAppear {
                if activePage.url != url {
                    activePage.load(URLRequest(url: url))
                }
            }
    }
}
