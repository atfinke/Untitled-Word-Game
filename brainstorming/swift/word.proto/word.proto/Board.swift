//
//  Board.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

class Board: CustomStringConvertible {

    // MARK: - Properties -

    private(set) var placements = [BoardPosition: UInt8]()

    // MARK: - Helpers -
    
    func place(letter: UInt8, at position: BoardPosition) {
        assert(isPositionOpen(position))
        placements[position] = letter
    }

    func isPositionOpen(_ position: BoardPosition) -> Bool {
        return placements[position] == nil
    }

    func anchors() -> Set<BoardPosition> {
        let filledPositions = placements.keys
        let anchors = Set(filledPositions
            .map { $0.neighbors() }
            .reduce([], +))
            .filter { !filledPositions.contains($0) }
        if anchors.isEmpty {
            return Set([BoardPosition(x: 0, y: 0)])
        } else {
            return anchors
        }
    }
    
    func pickUp(except: Set<BoardPosition> = []) -> [UInt8] {
        var copy = [BoardPosition: UInt8]()
        for pos in except {
            copy[pos] = placements[pos]
        }
        let letters = placements.values
        placements.removeAll()
        placements = copy
        return Array(letters)
    }
    
    // MARK: - CustomStringConvertible -
    
    var description: String {
        var minX = 0
        var maxX = 0
        var minY = 0
        var maxY = 0
        for pos in placements.keys {
            minX = min(minX, pos.x)
            maxX = max(maxX, pos.x)
            minY = min(minY, pos.y)
            maxY = max(maxY, pos.y)
        }
        var lines = [String]()
        for y in minY...maxY {
            var line = ""
            for x in minX...maxX {
                if let value = placements[BoardPosition(x: x, y: y)], let letter = String(bytes: [value], encoding: .utf8) {
                    line += " \(letter) "
                } else {
                    line += " - "
                }
            }
            lines.append(line)
        }
        
        return lines.reversed().joined(separator: "\n")
        
    }
}
