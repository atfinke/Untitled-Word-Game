//
//  NSExtensions.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func stylized(string: String, size: CGFloat, weight: UIFont.Weight) -> NSAttributedString {
        let initalFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = initalFont.fontDescriptor.withDesign(.rounded) else {
            fatalError()
        }
        let font = UIFont(descriptor: descriptor, size: size)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
}
