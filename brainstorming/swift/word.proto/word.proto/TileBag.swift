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
    static let characterTileCounts: [Character: Int] = [
        "A": 9,
        "B": 2,
        "C": 2,
        "D": 4,
        "E": 12,
        "F": 2,
        "G": 3,
        "H": 2,
        "I": 9,
        "J": 1,
        "K": 1,
        "L": 4,
        "M": 2,
        "N": 6,
        "O": 8,
        "P": 2,
        "Q": 1,
        "R": 6,
        "S": 4,
        "T": 6,
        "U": 4,
        "V": 2,
        "W": 2,
        "X": 1,
        "Y": 2,
        "Z": 1,
    ]
    
    var remainingTiles = [Character]()
    
    // MARK: - Initalization -
    
    init() {
        var tiles = [Character]()
        for (key, number) in TileBag.characterTileCounts {
            for _ in 0..<number {
                tiles.append(key)
            }
        }
        remainingTiles = tiles.shuffled()
    }
    
    // MARK: - Helpers -
    
    func grab(tiles: Int = 1) -> [Character] {
        var grabbed = [Character]()
        for _ in 0..<tiles {
            let tile = remainingTiles.removeFirst()
            grabbed.append(tile)
        }
        return grabbed
    }
}
