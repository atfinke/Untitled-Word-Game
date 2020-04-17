//
//  Board.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class Board {
    
    var placements = [BoardPosition: String]()
    
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
}
