//
//  GameAI.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class GameAI {

    private let dictionary: Dictionary
    private let queue = OperationQueue()

    private let serialQueue = DispatchQueue(label: "sd")

    // MARK: - State -

    private var board: Board
    private var tiles: [UInt8]

    private var verticalCrossChecks = [BoardPosition: [UInt8]]()
    private var horizontalCrossChecks = [BoardPosition: [UInt8]]()

    private var foundWords = [[UInt8]]()

    init(dictionary: Dictionary, board: Board) {
        self.dictionary = dictionary
        self.board = board
        self.tiles = []
    }

    // could make better by only looking at updated positions
    func updateCrossChecks() {
        var verticalCrossChecks = [BoardPosition: [UInt8]]()
        var horizontalCrossChecks = [BoardPosition: [UInt8]]()
        for anchor in board.anchors() {
            verticalCrossChecks[anchor] = crossCheck(board: board, for: tiles, at: anchor, axis: .vertical)
            horizontalCrossChecks[anchor] = crossCheck(board: board, for: tiles, at: anchor, axis: .horizontal)
        }
        self.verticalCrossChecks = verticalCrossChecks
        self.horizontalCrossChecks = horizontalCrossChecks
    }

    func isLetterValid(_ letter: UInt8, at position: BoardPosition, axis: Axis) -> Bool {
        switch axis {
        case .horizontal:
            if let crossCheck = horizontalCrossChecks[position] {
                return crossCheck.contains(letter)
            }
        case .vertical:
            if let crossCheck = verticalCrossChecks[position] {
                return crossCheck.contains(letter)
            }
        }
        return true
    }

    func moves(for board: Board, with tiles: [UInt8]) {
        self.board = board
        self.tiles = tiles
        self.foundWords = []

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
//        let words = Set(foundWords).compactMap { word -> String? in
//            return String(bytes: word, encoding: .utf8)
//        }
//        print(words.sorted())
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
                       node: node,
                       tiles: tiles,
                       axis: axis)
        } else {
            buildSuffix(anchor: anchor,
                       position: anchor,
                       prefix: [],
                       node: dictionary.root,
                       tiles: tiles,
                       axis: axis)

            var length = 1
            while board.isPositionOpen(position) && !board.anchors().contains(position) && length <= tiles.count {
                buildPrefix(anchor: anchor,
                          position: position,
                          prefix: [],
                          node: dictionary.root,
                          tiles: tiles,
                          axis: axis)
                position = position.offset(nextDirection)
                length += 1
            }
        }
    }

    // MARK: - Main Logic -

    private func handlePossibleMove(prefix: [UInt8], axis: Axis) {
//        let word = prefix.joined()
        let isValid = dictionary.isValid(word: prefix)
        assert(isValid)
        foundWords.append(prefix)
    }

    private func buildSuffix(anchor: BoardPosition,
                            position: BoardPosition,
                            prefix: [UInt8],
                            node: Node,
                            tiles: [UInt8],
                            axis: Axis) {
        let nextDirection: Direction = axis == .horizontal ? .right : .bottom

        if let existingLetter = board.placements[position] {
            guard let existingLetterNode = node.edges[existingLetter] else { return }
            let (newPrefix, newTiles) = prefixAndTiles(with: existingLetter,
                                                       prefix: prefix,
                                                       tiles: tiles,
                                                       removeTile: false)
            buildSuffix(anchor: anchor,
                       position: position.offset(nextDirection),
                       prefix: newPrefix,
                       node: existingLetterNode,
                       tiles: newTiles,
                       axis: axis)
        } else {
            if anchor != position && node.isEOW {
                serialQueue.async {
//                    let dir: Direction = axis == .horizontal ? .left : .top
//                    print("\na:\(anchor), p: \(position.offset(dir))")
                    self.handlePossibleMove(prefix: prefix, axis: axis)
                }
            }
            for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && isLetterValid(edgeLetter, at: position, axis: axis.other) {
                let (newPrefix, newTiles) = prefixAndTiles(with: edgeLetter,
                                                           prefix: prefix,
                                                           tiles: tiles)
                buildSuffix(anchor: anchor,
                           position: position.offset(nextDirection),
                           prefix: newPrefix,
                           node: edgeNode,
                           tiles: newTiles,
                           axis: axis)
            }
        }
    }

    private func buildPrefix(anchor: BoardPosition,
                           position: BoardPosition,
                           prefix: [UInt8],
                           node: Node,
                           tiles: [UInt8],
                           axis: Axis) {
        let nextDirection: Direction = axis == .horizontal ? .right : .bottom

        guard anchor != position else {
            buildSuffix(anchor: anchor,
                       position: position,
                       prefix: prefix,
                       node: node,
                       tiles: tiles,
                       axis: axis)
            return
        }

        for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && isLetterValid(edgeLetter, at: position, axis: axis.other) {
            let (newPrefix, newTiles) = prefixAndTiles(with: edgeLetter,
                                                       prefix: prefix,
                                                       tiles: tiles)
            buildPrefix(anchor: anchor,
                      position: position.offset(nextDirection),
                      prefix: newPrefix,
                      node: edgeNode,
                      tiles: newTiles,
                      axis: axis)
        }
    }

    // MARK: - Helpers -

    private func prefixAndTiles(with letter: UInt8,
                                prefix: [UInt8],
                                tiles: [UInt8],
                                removeTile: Bool = true) -> (prefix: [UInt8], tiles: [UInt8]) {
        var prefixCopy = prefix
        prefixCopy.append(letter)

        var tilesCopy = tiles
        if removeTile {
            guard let index = tilesCopy.firstIndex(of: letter) else { fatalError() }
            tilesCopy.remove(at: index)
        }
        return (prefixCopy, tilesCopy)
    }

    private func crossCheck(board: Board, for letters: [UInt8], at position: BoardPosition, axis: Axis) -> [UInt8] {
        var prefix = [UInt8]()
        let prefixDirection: Direction = axis == .vertical ? .top : .left
        var pos = position.offset(prefixDirection)
        while let letter = board.placements[pos] {
            prefix.insert(letter, at: 0)
            pos = pos.offset(prefixDirection)
        }

        var suffix = [UInt8]()
        let suffixDirection: Direction = axis == .vertical ? .bottom : .right
        pos = position.offset(suffixDirection)
        while let letter = board.placements[pos] {
            suffix.append(letter)
            pos = pos.offset(suffixDirection)
        }

        let start = prefix
        let end = suffix
        var validLetters = [UInt8]()
        for letter in letters {
            let word = start + [letter] + end
            if dictionary.isValid(word: word) {
                validLetters.append(letter)
            }
        }
        return validLetters
    }

}
