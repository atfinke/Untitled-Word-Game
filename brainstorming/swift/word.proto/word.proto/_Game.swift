//
//  _Game.swift
//  word.proto
//
//  Created by Andrew Finke on 4/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class _Game {

    let board = Board()
    let gameAI: GameAI
    let tileBag = TileBag()

    init() {
        let placements = [
            BoardPosition(x: 0, y: 5): "E",
            BoardPosition(x: 0, y: 4): "T",
            BoardPosition(x: 0, y: 3): "H",
            BoardPosition(x: 0, y: 2): "E",
            BoardPosition(x: 0, y: 1): "R",

            BoardPosition(x: 0, y: 0): "E",
            BoardPosition(x: 0, y: -1): "A",
            BoardPosition(x: 0, y: -2): "L",
            BoardPosition(x: 0, y: -3): "L",
            BoardPosition(x: 0, y: -4): "Y",

            BoardPosition(x: -2, y: 4): "O",
            BoardPosition(x: -1, y: 4): "U",
            BoardPosition(x: 1, y: 4): "D",
            BoardPosition(x: 2, y: 4): "O",
            BoardPosition(x: 3, y: 4): "I",
            BoardPosition(x: 4, y: 4): "N",
            BoardPosition(x: 5, y: 4): "G"
        ]
        var aaa = [BoardPosition: UInt8]()
        for a in placements {
            aaa[a.key] = UInt8(a.value.unicodeScalars.first!.value)
        }
        board.placements = aaa

        let gameDictionary = Dictionary()
        gameAI = GameAI(dictionary: gameDictionary, board: board)
    }

    func move() {
        let tiles: [UInt8] = ["A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G"].map({ UInt8($0.unicodeScalars.first!.value) })
        gameAI.moves(for: board, with: tiles)
    }

}
