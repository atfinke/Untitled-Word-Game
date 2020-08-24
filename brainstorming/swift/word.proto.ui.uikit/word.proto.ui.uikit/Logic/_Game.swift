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
        var tiles = [UInt8]()
        
        init(_ name: Int) {
            self.name = name
        }
    }
    
    // MARK: - Properties -
    
    let board = Board()
    private let gameAI: GameAI
    let tileBag = TileBag()
    private let dictionary = Dictionary()
    
    private var playerTurnIndex = 0
    private let players = [_Player(1), _Player(2), _Player(3), _Player(4)]
    
    private var minWordValue = 0
    
    // MARK: - Initalization -
    
    init() {
        gameAI = GameAI(dictionary: dictionary, board: board)
        for player in players {
            player.tiles = tileBag.grab(tiles: MAX_TILE_COUNT)
        }
    }
    
    // MARK: - Helpers -
    
    func move() -> GameAI.Move? {
        let player = players[playerTurnIndex]
        playerTurnIndex += 1
        if playerTurnIndex == players.count {
            playerTurnIndex = 0
        }
        var m: GameAI.Move?
        let moves = gameAI.moves(for: board, with: player.tiles)
        let specialMoves = moves.filter { $0.isSpecial }
        let regularMoves = moves
            .filter { !$0.isSpecial }
            .sorted(by: { $0.value > $1.value })

        if let move = regularMoves.first, move.value >= minWordValue {
            for item in move.placed {
                board.place(letter: item.value, at: item.key)
                guard let index = player.tiles.firstIndex(of: item.value) else { fatalError() }
                player.tiles.remove(at: index)
            }
            if player.tiles.count < MAX_TILE_COUNT {
                player.tiles.append(contentsOf: tileBag.grab(tiles: MAX_TILE_COUNT - player.tiles.count))
            }
            m = move
            minWordValue = move.value
            print("\nPlayer \(player.name) goes, \(move.value) points")
        } else if let move = specialMoves.first {
            m = move
            for item in move.placed {
                board.place(letter: item.value, at: item.key)
                guard let index = player.tiles.firstIndex(of: item.value) else { fatalError() }
                player.tiles.remove(at: index)
            }
            if player.tiles.count < MAX_TILE_COUNT {
                player.tiles.append(contentsOf: tileBag.grab(tiles: MAX_TILE_COUNT - player.tiles.count))
            }
            if move.placed.values.contains(68) {
                board.pickUp(except: move.uses)
                print("used a d")
            }
            minWordValue = 0
            print("\nPlayer \(player.name) goes, plays special")
        } else {
            player.tiles.append(contentsOf: board.pickUp())
            minWordValue = 0
            print("\nPlayer \(player.name) can't go, picks up board")
        }
        
        print(board)
        print("Letters:\n\(players.map({ "\($0.name): \(String(bytes: $0.tiles, encoding: .utf8)!)" }).joined(separator: "\n"))")
        
        if player.tiles.count == 0 {
            print("game over")
            exit(0)
        }
        
        return m
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
