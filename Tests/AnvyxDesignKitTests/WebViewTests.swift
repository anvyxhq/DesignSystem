//
//  WebViewTests.swift
//  AnvyxDesignKit
//
//  Created by AnhPT on 10/07/2026.
//

import XCTest
import SwiftUI
import WebKit
@testable import AnvyxDesignKit

@MainActor
final class WebViewTests: XCTestCase {

    func testConstructsWithSelfManagedPage() throws {
        guard #available(iOS 26, *) else {
            throw XCTSkip("AnvyxWebView requires iOS 26")
        }
        _ = AnvyxWebView(url: URL(string: "https://example.com")!)
    }

    func testConstructsWithSharedPage() throws {
        guard #available(iOS 26, *) else {
            throw XCTSkip("AnvyxWebView requires iOS 26")
        }
        let page = WebPage()
        _ = AnvyxWebView(url: URL(string: "https://example.com")!, page: page)
    }
}
