//
//  Haptics.swift
//  spin
//

#if os(watchOS)
import WatchKit
#elseif os(iOS)
import UIKit
#endif

enum Haptics {
    static func spinStarted() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.start)
        #elseif os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }

    static func landed() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #elseif os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
}
