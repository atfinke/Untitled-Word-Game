//
//  BoardPosition.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

struct BoardPosition: Hashable, CustomStringConvertible {

    // MARK: - Properties -

    let x, y: Int

    // MARK: - Helpers -

    func offset(_ direction: Direction, by dx: Int = 1) -> BoardPosition {
        switch direction {
        case .left:
            return BoardPosition(x: x - dx, y: y)
        case .right:
            return BoardPosition(x: x + dx, y: y)
        case .top:
            return BoardPosition(x: x, y: y + dx)
        case .bottom:
            return BoardPosition(x: x, y: y - dx)
        }
    }

    func neighbors() -> [BoardPosition] {
        return [
            offset(.left),
            offset(.right),
            offset(.top),
            offset(.bottom)
        ]
    }

    // MARK: - CustomStringConvertible -

    var description: String {
        return "(\(x), \(y))"
    }
}
