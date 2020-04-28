//
//  ViewController.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/20/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func stylized(string: String, size: CGFloat, weight: UIFont.Weight) -> NSAttributedString {
        let initalFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = initalFont.fontDescriptor.withDesign(.rounded) else {
            fatalError()
        }
        #if os(macOS)
        guard let font = SKFont(descriptor: descriptor, size: size) else {
            fatalError()
        }
        #else
        let font = UIFont(descriptor: descriptor, size: size)
        #endif

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension UIColor {
    static var gameBlueColor: UIColor {
        return UIColor(displayP3Red: 49 / 255,
                       green: 133 / 255,
                       blue: 252 / 255,
                       alpha: 1)
    }
}

struct Design {
    static let tileSize = CGSize(width: 50, height: 50)
    static let tileCornerRadius: CGFloat = 10
}

class Tile: UIView {
    
    init(letter: String) {
        super.init(frame: CGRect(origin: .zero, size: Design.tileSize))
        layer.cornerRadius = Design.tileCornerRadius
        layer.cornerCurve = .continuous
        backgroundColor = .gameBlueColor
        
        let label = UILabel(frame: bounds)
        label.attributedText = NSAttributedString.stylized(string: letter, size: 28, weight: .semibold)
        label.textAlignment = .center
        addSubview(label)
        
        let lllabel = UILabel(frame: bounds)
        lllabel.attributedText = NSAttributedString.stylized(string: "4", size: 14, weight: .medium)
        lllabel.textAlignment = .center
//        addSubview(lllabel)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lastPos = view.center
        for letter in "ANDREW" {
            let tile = Tile(letter: "\(letter)")
            view.addSubview(tile)
            tile.center = lastPos
            lastPos = CGPoint(x: tile.frame.midX + tile.frame.width + 5, y: lastPos.y)
        }
        
    }
}

