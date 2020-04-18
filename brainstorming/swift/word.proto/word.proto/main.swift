//
//  main.swift
//  word.proto
//
//  Created by Andrew Finke on 4/15/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation



class _Game {
    
    let board = Board()
    let gameAI: GameAI
    let tileBag = TileBag()
    
    init() {
        board.placements = [
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
            BoardPosition(x: 5, y: 4): "G",
        ]
        

        guard let url = Bundle.main.url(forResource: "filtered_sorted_words", withExtension: "txt"),
            let validWords = try? String(contentsOf: url).split(separator: "\n") else { fatalError() }

        print("loading \(validWords.count) words")
        let gameDictionaryDate = Date()
        let gameDictionary = Dictionary(words: validWords)
        print("Done in: \(-gameDictionaryDate.timeIntervalSinceNow)")
        gameAI = GameAI(dictionary: gameDictionary, board: board)
    }
    
    func move() {
        let tiles = ["A","B","C","D","E","F","G","A","B","C","D","E","F","G","A","B","C","D","E","F","G","A","B","C","D","E","F","G"]
        gameAI.moves(for: board, with: tiles)
    }
    
}

let a = _Game()



print("starting ai move")
let date = Date()
a.move()
print("Done in: \(-date.timeIntervalSinceNow)")

