//
//  GameAI.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class GameAI {
    
    // MARK: - Types -
    
    struct Move {
        let placed: [BoardPosition: UInt8]
        let value: Int
    }
    
    // MARK: - Properties -

    private let dictionary: Dictionary
    private let queue = OperationQueue()

    private let movesQueue = DispatchQueue(label: "com.andrewfinke.moves")

    // MARK: - State -

    private var board: Board
    private var tiles: [UInt8]

    private var verticalCrossChecks = [BoardPosition: [UInt8: Int]]()
    private var horizontalCrossChecks = [BoardPosition: [UInt8: Int]]()

    private var moves = [Move]()
    
    // MARK: - Initalization -

    init(dictionary: Dictionary, board: Board) {
        self.dictionary = dictionary
        self.board = board
        self.tiles = []
    }
    
    // MARK: - Check Moves -

    func moves(for board: Board, with tiles: [UInt8]) -> [Move] {
        self.board = board
        self.tiles = tiles
        self.moves = []

        updateCrossChecks()
        for anchor in board.anchors() {
            let horizontalOperation = BlockOperation {
                self.checkMoves(at: anchor, with: tiles, axis: .horizontal)
            }
            queue.addOperation(horizontalOperation)
            let verticalOperation = BlockOperation {
                self.checkMoves(at: anchor, with: tiles, axis: .vertical)
            }
            queue.addOperation(verticalOperation)
        }
        queue.waitUntilAllOperationsAreFinished()
        return movesQueue.sync {
            return self.moves
        }
    }

    private func checkMoves(at anchor: BoardPosition, with tiles: [UInt8], axis: Axis) {
        Thread.current.name = "GameAI checkMoves: \(anchor), \(axis)"
        let nextDirection: Direction = axis == .horizontal ? .left : .top
        var position = anchor.offset(nextDirection)

        if let _ = board.placements[position] {
            var prefix = [UInt8]()
            while let letter = board.placements[position] {
                prefix.insert(letter, at: 0)
                position = position.offset(nextDirection)
            }
            var node = dictionary.root
            for letter in prefix {
                guard let newNode = node.edges[letter] else {
                    fatalError("word on board not in dictionary: \(prefix)")
                }
                node = newNode
            }
            buildSuffix(anchor: anchor,
                       position: anchor,
                       prefix: prefix,
                       placed: [:],
                       node: node,
                       tiles: tiles,
                       axis: axis)
        } else {
            buildSuffix(anchor: anchor,
                       position: anchor,
                       prefix: [],
                       placed: [:],
                       node: dictionary.root,
                       tiles: tiles,
                       axis: axis)

            var length = 1
            while board.isPositionOpen(position) && !board.anchors().contains(position) && length <= tiles.count {
                buildPrefix(anchor: anchor,
                          position: position,
                          prefix: [],
                          placed: [:],
                          node: dictionary.root,
                          tiles: tiles,
                          axis: axis)
                position = position.offset(nextDirection)
                length += 1
            }
        }
    }

    // MARK: - Main Logic -

    private func found(move: Move) {
        moves.append(move)
    }
    
    private func score(placed: [BoardPosition: UInt8], finalLetterPosition: BoardPosition, axis: Axis) -> Int {
        // Calc value of word along op axis
        let opAxisPointChecks = axis == .horizontal ? verticalCrossChecks : horizontalCrossChecks
        var crossPoints = 0
        for (position, letter) in placed {
            // since we only cross check anchors (open spots next to letters), non-cross checks are zero
            let letterCrossPoints = opAxisPointChecks[position]?[letter] ?? 0
            crossPoints += letterCrossPoints
        }
        
        let sort: ((BoardPosition, BoardPosition) -> Bool)
        let prevDirection: Direction
        let nextDirection: Direction
        if axis == .horizontal {
            sort = { $0.x < $1.x }
            prevDirection = .left
            nextDirection = .right
        } else {
            sort = { $0.y > $1.y }
            prevDirection = .top
            nextDirection = .bottom
        }
        
        // Calc value of word along axis from first placed to last letter on board/placed
        var coreValue = 0
        let minPosition = placed.keys.sorted(by: sort)[0]
        var position = minPosition
        let tooFarPosition = finalLetterPosition.offset(nextDirection)
        while position != tooFarPosition {
            let letter: UInt8
            if let new = placed[position] {
                letter = new
            } else if let existing = board.placements[position] {
                letter = existing
            } else {
                fatalError()
            }
            guard let value = TileBag.characterTileValues[letter] else { fatalError() }
            coreValue += value
            position = position.offset(nextDirection)
        }
        
        // Calc value of word along axis before first placed letter
        var preValue = 0
        var prevPosition = minPosition.offset(prevDirection)
        while let prevPlacement = board.placements[prevPosition] {
            guard let value = TileBag.characterTileValues[prevPlacement] else { fatalError() }
            preValue += value
            prevPosition = prevPosition.offset(prevDirection)
        }
        
        return crossPoints + coreValue + preValue
    }

    private func buildSuffix(anchor: BoardPosition,
                            position: BoardPosition,
                            prefix: [UInt8],
                            placed: [BoardPosition: UInt8],
                            node: Node,
                            tiles: [UInt8],
                            axis: Axis) {
        let nextDirection: Direction = axis == .horizontal ? .right : .bottom

        if let existingLetter = board.placements[position] {
            guard let existingLetterNode = node.edges[existingLetter] else { return }
            let (newPrefix, newTiles, newPlaced) = state(forNew: existingLetter, at: position, prefix: prefix, tiles: tiles, placed: placed, usedTile: false)
            
            buildSuffix(anchor: anchor,
                       position: position.offset(nextDirection),
                       prefix: newPrefix,
                       placed: newPlaced,
                       node: existingLetterNode,
                       tiles: newTiles,
                       axis: axis)
        } else {
            if anchor != position && node.isEOW {
                let prevDirection: Direction = axis == .horizontal ? .left : .top
                let value = score(placed: placed, finalLetterPosition: position.offset(prevDirection), axis: axis)
                let move = Move(placed: placed, value: value)
                movesQueue.async {
                    self.found(move: move)
                }
            }
            for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && isLetterCrossValid(edgeLetter, at: position, axis: axis.other) {
                let (newPrefix, newTiles, newPlaced) = state(forNew: edgeLetter, at: position, prefix: prefix, tiles: tiles, placed: placed, usedTile: true)
                buildSuffix(anchor: anchor,
                           position: position.offset(nextDirection),
                           prefix: newPrefix,
                           placed: newPlaced,
                           node: edgeNode,
                           tiles: newTiles,
                           axis: axis)
            }
        }
    }

    private func buildPrefix(anchor: BoardPosition,
                           position: BoardPosition,
                           prefix: [UInt8],
                           placed: [BoardPosition: UInt8],
                           node: Node,
                           tiles: [UInt8],
                           axis: Axis) {
        let nextDirection: Direction = axis == .horizontal ? .right : .bottom

        guard anchor != position else {
            buildSuffix(anchor: anchor,
                       position: position,
                       prefix: prefix,
                       placed: placed,
                       node: node,
                       tiles: tiles,
                       axis: axis)
            return
        }

        for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && isLetterCrossValid(edgeLetter, at: position, axis: axis.other) {
            let (newPrefix, newTiles, newPlaced) = state(forNew: edgeLetter, at: position, prefix: prefix, tiles: tiles, placed: placed, usedTile: true)
            buildPrefix(anchor: anchor,
                      position: position.offset(nextDirection),
                      prefix: newPrefix,
                      placed: newPlaced,
                      node: edgeNode,
                      tiles: newTiles,
                      axis: axis)
        }
    }
    
    // MARK: - Cross Checks -
    
    // could make better by only looking at updated positions
    func updateCrossChecks() {
        var verticalCrossChecks = [BoardPosition: [UInt8: Int]]()
        var horizontalCrossChecks = [BoardPosition: [UInt8: Int]]()
        for anchor in board.anchors() {
            verticalCrossChecks[anchor] = crossCheck(board: board, for: tiles, at: anchor, axis: .vertical)
            horizontalCrossChecks[anchor] = crossCheck(board: board, for: tiles, at: anchor, axis: .horizontal)
        }
        self.verticalCrossChecks = verticalCrossChecks
        self.horizontalCrossChecks = horizontalCrossChecks
    }
    
    private func crossCheck(board: Board, for letters: [UInt8], at position: BoardPosition, axis: Axis) -> [UInt8: Int] {
        func check(prefix: Bool) -> (letters: [UInt8], value: Int) {
            var letters = [UInt8]()
            var lettersValue = 0
            let direction: Direction
            if prefix {
                direction = axis == .vertical ? .top : .left
            } else {
                direction = axis == .vertical ? .bottom : .right
            }
            var pos = position.offset(direction)
            while let letter = board.placements[pos] {
                if prefix {
                    letters.insert(letter, at: 0)
                } else {
                    letters.append(letter)
                }
                pos = pos.offset(direction)
                guard let value = TileBag.characterTileValues[letter] else { fatalError() }
                lettersValue += value
            }
            return (letters, lettersValue)
        }
        
        let (prefix, prefixValue) = check(prefix: true)
        let (suffix, suffixValue) = check(prefix: false)
        let endsValue = prefixValue + suffixValue

        var validLetters = [UInt8: Int]()
        for letter in letters {
            guard let letterValue = TileBag.characterTileValues[letter] else { fatalError() }
            let word = prefix + [letter] + suffix
            if dictionary.isValid(word: word) {
                if word.count == 1 {
                    validLetters[letter] = 0
                } else {
                    validLetters[letter] = letterValue + endsValue
                }
            }
        }
        return validLetters
    }

    func isLetterCrossValid(_ letter: UInt8, at position: BoardPosition, axis: Axis) -> Bool {
        switch axis {
        case .horizontal:
            if let crossCheck = horizontalCrossChecks[position] {
                return crossCheck.keys.contains(letter)
            }
        case .vertical:
            if let crossCheck = verticalCrossChecks[position] {
                return crossCheck.keys.contains(letter)
            }
        }
        return true
    }
    
    // MARK: - Helpers -
    
    private func state(forNew letter: UInt8,
                       at position: BoardPosition,
                       prefix: [UInt8],
                       tiles: [UInt8],
                       placed: [BoardPosition: UInt8],
                       usedTile: Bool) -> (prefix: [UInt8], tiles: [UInt8], placed: [BoardPosition: UInt8]) {
        
        var prefixCopy = prefix
        prefixCopy.append(letter)
        
        var placedCopy = placed
        var tilesCopy = tiles
        if usedTile {
            guard let index = tilesCopy.firstIndex(of: letter) else { fatalError() }
            tilesCopy.remove(at: index)
            placedCopy[position] = letter
        }
        return (prefixCopy, tilesCopy, placedCopy)
    }

}
