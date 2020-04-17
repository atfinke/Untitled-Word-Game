//
//  main.swift
//  word.proto
//
//  Created by Andrew Finke on 4/15/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

private let blkCount = 1
private let chrCounts: [Character: Int] = [
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
private let chrValues: [Character: UInt32] = [
    "A": 65,
    "B": 66,
    "C": 67,
    "D": 68,
    "E": 69,
    "F": 70,
    "G": 71,
    "H": 72,
    "I": 73,
    "J": 74,
    "K": 75,
    "L": 76,
    "M": 77,
    "N": 78,
    "O": 79,
    "P": 80,
    "Q": 81,
    "R": 82,
    "S": 83,
    "T": 84,
    "U": 85,
    "V": 86,
    "W": 87,
    "X": 88,
    "Y": 89,
    "Z": 90,
]


//let words = [
//    "HELLO",
//    "MOON"
//]

guard let url = Bundle.main.url(forResource: "scrabble_words", withExtension: "txt"),
    let words = try? String(contentsOf: url).split(separator: "\n") else { fatalError() }
////
let wordsa = [
    "BOY",
    "MOOON",
//    "COW",
    "HIKE",
    "BY",
    "LEGO",
    "ORANGE",
    "EGG",
    "SO",
    "HAH"
]

let tiles = [
    "B",
    "H",
    "I",
    "K",
    "Y",
    "A"
]

func isValid(word: String) {
    var n = root
    for a in word {
        n = n.edges["\(a)"]!
    }
    assert(n.isEOW)
}

let date = Date()
let root = Node(isEOW: false)
let queue = OperationQueue()


for word in words {
    let unique = Set(word)
    for chr in unique {
        let count = word.split(separator: chr, omittingEmptySubsequences: false).count - 1
        if count > blkCount + chrCounts[chr]! {
            print("invalid: \(word), \(chr): \(count), \(chrCounts[chr]!)")
            continue
        }
    }
    root.add(values: word.compactMap { "\($0)" } )
}

print(date.timeIntervalSinceNow)

let board = Board()
board.placements = [
    BoardPosition(x: 0, y: 5): "H",
    BoardPosition(x: 0, y: 4): "E",
    BoardPosition(x: 0, y: 3): "L",
    BoardPosition(x: 0, y: 2): "L",
    BoardPosition(x: 0, y: 1): "O",
    
    BoardPosition(x: 2, y: 5): "H",
    BoardPosition(x: 2, y: 4): "E",
    BoardPosition(x: 2, y: 3): "L",
    BoardPosition(x: 2, y: 2): "L",
    BoardPosition(x: 2, y: 1): "O",
    
    BoardPosition(x: 1, y: 3): "I",
    BoardPosition(x: 3, y: 3): "Y"
    
]

func crossCheck(letter: String, position: BoardPosition) -> Bool {
    var word = [letter]
    var pos = position.offset(.top)
    while let letter = board.placements[pos] {
        word.insert(letter, at: 0)
        pos = pos.offset(.top)
    }
    
    pos = position.offset(.bottom)
    while let letter = board.placements[pos] {
        word.append(letter)
        pos = pos.offset(.bottom)
    }
    
    if word.count > 1 {
        var node = root
        for letter in word {
            if let nextNode = node.edges[letter] {
                node = nextNode
            } else {
                return false
            }
        }
    }
    return true
}


func handlePossibleMove(prefix: [String]) {
    isValid(word: prefix.joined())
    print("\(prefix.joined())")
}

func prefixAndTiles(with letter: String,
                    prefix: [String],
                    tiles: [String],
                    removeTile: Bool = true) -> (prefix: [String], tiles: [String]) {
    var prefixCopy = prefix
    prefixCopy.append(letter)
    
    var tilesCopy = tiles
    if removeTile {
        guard let index = tilesCopy.firstIndex(of: letter) else { fatalError() }
        tilesCopy.remove(at: index)
    }
    return (prefixCopy, tilesCopy)
}

var seen = [String]()
func add(anchor: BoardPosition, position: BoardPosition, prefix: [String], node: Node, tiles: [String], e: String) {
    let str = "\(anchor)\(position),\(prefix),\(tiles),\(e)"
    if seen.contains(str) {
        fatalError()
    }
    seen.append(str)
}


func buildRight(anchor: BoardPosition, position: BoardPosition, prefix: [String], node: Node, tiles: [String]) {
//    print("r| a:\(anchor), p:\(position), x:\(prefix.joined()), t:\(tiles.joined())")
    add(anchor: anchor, position: position, prefix: prefix, node: node, tiles: tiles, e: "R")
    if let existingLetter = board.placements[position] {
//        print("existing letter: \(existingLetter)")
        guard let existingLetterNode = node.edges[existingLetter] else { return }
        let (newPrefix, newTiles) = prefixAndTiles(with: existingLetter,
                                                   prefix: prefix,
                                                   tiles: tiles,
                                                   removeTile: false)
        buildRight(anchor: anchor,
                   position: position.offset(.right),
                   prefix: newPrefix,
                   node: existingLetterNode,
                   tiles: newTiles)
    } else {
//        print("open")
        if anchor != position && node.isEOW {
            print("\nAnchor: \(anchor), lastPosition: \(position.offset(.left))")
            handlePossibleMove(prefix: prefix)
        }
        for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && crossCheck(letter: edgeLetter, position: position) {
            let (newPrefix, newTiles) = prefixAndTiles(with: edgeLetter,
                                                       prefix: prefix,
                                                       tiles: tiles)
            buildRight(anchor: anchor,
                       position: position.offset(.right),
                       prefix: newPrefix,
                       node: edgeNode,
                       tiles: newTiles)
        }
    }
}

func buildLeft(anchor: BoardPosition, position: BoardPosition, prefix: [String], node: Node, tiles: [String]) {
//    print("l| a:\(anchor), p:\(position), x:\(prefix.joined()), t:\(tiles.joined())")
    add(anchor: anchor, position: position, prefix: prefix, node: node, tiles: tiles, e: "L")
    guard anchor != position else {
        buildRight(anchor: anchor,
                   position: position,
                   prefix: prefix,
                   node: node,
                   tiles: tiles)
        return
    }
    
    for (edgeLetter, edgeNode) in node.edges where tiles.contains(edgeLetter) && crossCheck(letter: edgeLetter, position: position) {
        let (newPrefix, newTiles) = prefixAndTiles(with: edgeLetter,
                                                   prefix: prefix,
                                                   tiles: tiles)
        buildLeft(anchor: anchor,
                  position: position.offset(.right),
                  prefix: newPrefix,
                  node: edgeNode,
                  tiles: newTiles)
    }
}

func computerMove() {
//    let smallAnch =
    for anchor in board.anchors() {
        var position = anchor.offset(.left)
        
        if let _ = board.placements[position] {
            var prefix = [String]()
            while let letter = board.placements[position] {
                prefix.insert(letter, at: 0)
                position = position.offset(.left)
            }
            var node = root
            for letter in prefix {
                guard let newNode = node.edges[letter] else {
                    fatalError("word on board not in dictionary")
                }
                node = newNode
            }
            buildRight(anchor: anchor,
                       position: anchor,
                       prefix: prefix,
                       node: node,
                       tiles: tiles)
        } else {
            buildRight(anchor: anchor,
                       position: anchor,
                       prefix: [],
                       node: root,
                       tiles: tiles)
            
            var length = 1
            while board.isPositionOpen(position) && !board.anchors().contains(position) && length <= tiles.count {
//                print("LEFT LENGTH \(length)\n")
                buildLeft(anchor: anchor,
                           position: position,
                           prefix: [],
                           node: root,
                           tiles: tiles)
                position = position.offset(.left)
                length += 1
            }
        }
    }
}

let datea = Date()
computerMove()
print(datea.timeIntervalSinceNow)
