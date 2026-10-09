//
//  Defaults.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/24/25.
//

import Defaults
import Foundation

extension Defaults.Keys {

    enum Game {
        static let difficulty = Key<String>("difficulty", default: "Beginner")
        static let customDifficulty = Key<[Int]>("customDifficulty", default: [-1, -1, -1])
    }

    enum General {
        static let appearance = Key<String>("appearance", default: "Light")
        static let toolbarDifficulty = Key<Bool>("toolbarDifficulty", default: false)
        static let scale = Key<CGFloat>("scale", default: 1.5)
        static let questions = Key<Bool>("questions", default: false)
        static let safeFirstClick = Key<Bool>("safeFirstClick", default: true)
        static let keepOnTop = Key<Bool>("keepOnTop", default: false)
    }

    enum Themes {
        static let theme = Key<String>("theme", default: "Classic")
        static let favorites = Key<[String]>(
            "favorites",
            default: [
                "Classic",
                "Classic Dark",
                "Classic 95",
            ])
    }

    enum Keys {

    }

    enum BestTimes {
        static let bestTimes = Key<[Double]>("bestTimes", default: [-1, -1, -1, -1, -1, -1, -1, -1, -1])
    }
}

extension Defaults {
    /// Defaults 7 has get/set only (no `_modify`), so mutate via copy-write helpers.
    static func toggle(_ key: Key<Bool>) {
        self[key] = !self[key]
    }

    static func update<Value>(_ key: Key<Value>, _ body: (inout Value) -> Void) {
        var value = self[key]
        body(&value)
        self[key] = value
    }
}
