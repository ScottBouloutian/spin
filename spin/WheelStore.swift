//
//  WheelStore.swift
//  spin
//

import Foundation
import Observation

struct WheelOption: Identifiable, Codable, Equatable {
    var id: UUID
    var label: String

    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}

@Observable
final class WheelStore {
    static let minOptions = 1
    static let maxOptions = 12

    var options: [WheelOption] {
        didSet { save() }
    }

    var themeID: String {
        didSet { UserDefaults.standard.set(themeID, forKey: Self.themeKey) }
    }

    var theme: WheelTheme {
        WheelTheme.theme(id: themeID)
    }

    private static let storageKey = "wheelOptions"
    private static let themeKey = "wheelTheme"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode([WheelOption].self, from: data),
           !saved.isEmpty {
            options = saved
        } else {
            options = Self.exampleOptions()
        }
        themeID = UserDefaults.standard.string(forKey: Self.themeKey) ?? WheelTheme.classic.id
    }

    static func exampleOptions() -> [WheelOption] {
        ["Pizza", "Sushi", "Tacos", "Burgers", "Salad", "Steak"].map { WheelOption(label: $0) }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(options) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}
