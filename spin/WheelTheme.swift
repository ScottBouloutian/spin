//
//  WheelTheme.swift
//  spin
//

import SwiftUI

struct WheelTheme: Identifiable {
    let id: String
    let name: String
    let background: Color
    let rim: Color
    let hubAccent: Color
    let labelColor: Color
    let slices: [Color]

    func sliceColor(at index: Int, of count: Int) -> Color {
        // Keep the last slice from matching the first where the wheel wraps around.
        if count > 1, index == count - 1, index % slices.count == 0 {
            return slices[slices.count / 2]
        }
        return slices[index % slices.count]
    }

    static let all: [WheelTheme] = [classic, rainbow, ocean, sunset]

    static func theme(id: String) -> WheelTheme {
        all.first { $0.id == id } ?? classic
    }

    static let classic = WheelTheme(
        id: "classic",
        name: "Classic",
        background: Color(red: 0.10, green: 0.13, blue: 0.26),
        rim: Color(red: 0.96, green: 0.94, blue: 0.89),
        hubAccent: Color(red: 0.99, green: 0.48, blue: 0.66),
        labelColor: Color(red: 0.10, green: 0.13, blue: 0.26),
        slices: [
            Color(red: 0.99, green: 0.48, blue: 0.66),
            Color(red: 0.42, green: 0.77, blue: 0.94),
            Color(red: 0.96, green: 0.94, blue: 0.89),
            Color(red: 1.00, green: 0.76, blue: 0.30),
        ]
    )

    static let rainbow = WheelTheme(
        id: "rainbow",
        name: "Rainbow",
        background: Color(red: 0.07, green: 0.07, blue: 0.09),
        rim: Color(red: 0.94, green: 0.94, blue: 0.95),
        hubAccent: Color(red: 0.93, green: 0.27, blue: 0.28),
        labelColor: .white,
        slices: [
            Color(red: 0.93, green: 0.27, blue: 0.28),
            Color(red: 0.98, green: 0.57, blue: 0.13),
            Color(red: 0.99, green: 0.79, blue: 0.19),
            Color(red: 0.28, green: 0.73, blue: 0.38),
            Color(red: 0.18, green: 0.66, blue: 0.72),
            Color(red: 0.24, green: 0.48, blue: 0.90),
            Color(red: 0.56, green: 0.35, blue: 0.86),
            Color(red: 0.90, green: 0.32, blue: 0.61),
        ]
    )

    static let ocean = WheelTheme(
        id: "ocean",
        name: "Ocean",
        background: Color(red: 0.04, green: 0.11, blue: 0.17),
        rim: Color(red: 0.89, green: 0.95, blue: 0.96),
        hubAccent: Color(red: 0.15, green: 0.65, blue: 0.70),
        labelColor: Color(red: 0.03, green: 0.15, blue: 0.20),
        slices: [
            Color(red: 0.31, green: 0.76, blue: 0.79),
            Color(red: 0.55, green: 0.83, blue: 0.98),
            Color(red: 0.93, green: 0.91, blue: 0.80),
            Color(red: 0.42, green: 0.80, blue: 0.62),
        ]
    )

    static let sunset = WheelTheme(
        id: "sunset",
        name: "Sunset",
        background: Color(red: 0.16, green: 0.06, blue: 0.19),
        rim: Color(red: 0.98, green: 0.93, blue: 0.85),
        hubAccent: Color(red: 0.96, green: 0.49, blue: 0.43),
        labelColor: Color(red: 0.25, green: 0.09, blue: 0.16),
        slices: [
            Color(red: 0.96, green: 0.49, blue: 0.43),
            Color(red: 0.99, green: 0.72, blue: 0.30),
            Color(red: 0.93, green: 0.42, blue: 0.61),
            Color(red: 0.99, green: 0.85, blue: 0.68),
        ]
    )
}
