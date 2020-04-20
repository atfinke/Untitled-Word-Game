//
//  _Game.swift
//  word.proto
//
//  Created by Andrew Finke on 4/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

let MAX_TILE_COUNT = 7

class _Game {
    
    // MARK: - Types -
    
    private class _Player {
        let name: Int
        var score = 0
        var tiles = [UInt8]()
        
        init(_ name: Int) {
            self.name = name
        }
    }
    
    // MARK: - Properties -
    
    private let board = Board()
    private let gameAI: GameAI
    private let tileBag = TileBag()
    private let dictionary = Dictionary()
    
    private var playerTurnIndex = 0
    private let players = [_Player(1), _Player(2), _Player(3), _Player(4)]
    
    // MARK: - Initalization -
    
    init() {
        gameAI = GameAI(dictionary: dictionary, board: board)
        for player in players {
            player.tiles = tileBag.grab(tiles: MAX_TILE_COUNT)
        }
    }
    
    // MARK: - Helpers -
    
    func move() {
        let player = players[playerTurnIndex]
        playerTurnIndex += 1
        if playerTurnIndex == players.count {
            playerTurnIndex = 0
        }
        
        let moves = gameAI.moves(for: board, with: player.tiles)
        
        if let move = moves.sorted(by: { $0.value > $1.value }).first {
            player.score += move.value
            for item in move.placed {
                board.place(letter: item.value, at: item.key)
                guard let index = player.tiles.firstIndex(of: item.value) else { fatalError() }
                player.tiles.remove(at: index)
            }
            player.tiles.append(contentsOf: tileBag.grab(tiles: MAX_TILE_COUNT - player.tiles.count))
            print("\nPlayer \(player.name) goes, +\(move.value) points")
        } else {
            print("\nPlayer \(player.name) can't go")
        }
        
        print(board)
        print("Scores: \(players.map({ "\($0.name): \($0.score)" }).joined(separator: ", "))")
        print("Letters:\n\(players.map({ "\($0.name): \(String(bytes: $0.tiles, encoding: .utf8)!)" }).joined(separator: "\n"))")
        
        if player.tiles.count == 0 {
            print("game over")
            exit(0)
        }
        //        for (index, move) in moves.sorted(by: { $0.value > $1.value }).enumerated() {
        //            let copy = Board()
        //            copy.placements = board.placements
        //            for item in move.placed {
        //                copy.place(letter: item.value, at: item.key)
        //            }
        //            print("\nMove #\(index + 1), (\(move.value) Points)")
        //            print("Placed: \(move.placed.values.compactMap({ String(bytes: [$0], encoding: .utf8)}))")
        //            print(copy)
        //        }
    }
    
}
