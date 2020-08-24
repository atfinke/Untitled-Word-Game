//
//  CGExtensions.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import CoreGraphics

extension CGSize {
    static var infinite: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
    
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }
}
