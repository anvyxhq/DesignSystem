//
//  TimedAction.swift
//  DesignSystem
//
//  Created by AnhPT on 10/07/2026.
//

import SwiftUI
import Combine

public extension View {
    /// Run `action` **once**, `interval` seconds after this view appears —
    /// declaratively, with no manual `Timer` / `Task` bookkeeping.
    ///
    /// The countdown is bound to the view's lifetime: SwiftUI starts it when the
    /// view is installed and cancels it when the view is removed. It also restarts
    /// whenever `id` changes, so each distinct `id` gets a fresh, full interval
    /// (e.g. a new toast replacing the current one).
    ///
    /// Built on `Timer.publish(…).autoconnect().first()`: `.first()` completes
    /// after the first tick, which tears down the subscription and invalidates the
    /// timer — a true one-shot with no leftover ticks. Uses run-loop mode
    /// `.common`, so it still fires while the user is scrolling.
    ///
    /// ```swift
    /// BannerView()
    ///     .anvyxTimer(after: 2.5, id: banner.id) { dismiss() }
    /// ```
    func anvyxTimer(
        after interval: TimeInterval,
        id: some Hashable,
        perform action: @escaping () -> Void
    ) -> some View {
        onReceive(
            Timer.publish(every: interval, on: .main, in: .common).autoconnect().first()
        ) { _ in
            action()
        }
        .id(id)
    }
}
