//
//  TileBag.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class TileBag {

    // MARK: - Properties -

    static let blankTileCount = 0
    
    static let characterTileCounts: [UInt8: Int] = {
        let raw = ["A": 9, "B": 2, "C": 2, "D": 4, "E": 12, "F": 2, "G": 3, "H": 2, "I": 9, "J": 1, "K": 1, "L": 4, "M": 2, "N": 6, "O": 8, "P": 2, "Q": 1, "R": 6, "S": 4, "T": 6, "U": 4, "V": 2, "W": 2, "X": 1, "Y": 2, "Z": 1]
        var converted = [UInt8: Int]()
        raw.forEach { converted[UInt8($0.key.unicodeScalars.first?.value ?? 0)] = $0.value }
        return converted
    }()
    
    static let characterTileValues: [UInt8: Int] = {
        let raw = ["A": 1, "B": 3, "C": 3, "D": 2, "E": 1, "F": 4, "G": 2, "H": 4, "I": 1, "J": 8, "K": 5, "L": 1, "M": 3, "N": 1, "O": 1, "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, "U": 1, "V": 5, "W": 4, "X": 8, "Y": 4, "Z": 10]
        var converted = [UInt8: Int]()
        raw.forEach { converted[UInt8($0.key.unicodeScalars.first?.value ?? 0)] = $0.value }
        return converted
    }()
    
    private var remainingTiles = [UInt8]()

    // MARK: - Initalization -

    init() {
        var tiles = [UInt8]()
        for (key, number) in TileBag.characterTileCounts {
            for _ in 0..<number {
                tiles.append(key)
            }
        }
        remainingTiles = tiles.shuffled()
    }

    // MARK: - Helpers -

    func grab(tiles: Int = 1) -> [UInt8] {
        var grabbed = [UInt8]()
        for _ in 0..<tiles {
            if !remainingTiles.isEmpty {
                let tile = remainingTiles.removeFirst()
                grabbed.append(tile)
            }
        }
        return grabbed
    }
    
    func remainCount() -> Int {
        return remainingTiles.count
    }
}
