//
//  Axis.swift
//  word.proto
//
//  Created by Andrew Finke on 4/17/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

enum Axis {
    case vertical, horizontal

    var other: Axis {
        switch self {

        case .vertical:
            return .horizontal
        case .horizontal:
            return .vertical
        }
    }
}
