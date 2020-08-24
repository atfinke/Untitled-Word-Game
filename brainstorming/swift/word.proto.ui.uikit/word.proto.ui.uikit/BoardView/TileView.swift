//
//  TileView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 5/3/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    enum State {
        case hidden, open
        case tileLockedNeutral, tileLockedValid, tileLockedInvalid
        case tilePlaced
    }
    
    enum LetterState {
        case none
        case some(letter: UInt8, value: Int)
    }
    
    var state: State = .hidden
    var letterState: LetterState = .none
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.text = "A"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(letterLabel)
        addSubview(valueLabel)
        
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.performWithoutAnimation {
            letterLabel.frame = bounds
        }
        
        switch state {
        case .hidden:
            alpha = 0.0
            layer.backgroundColor = UIColor.clear.cgColor
        case .open:
            alpha = 1.0
            layer.backgroundColor = UIColor(
                displayP3Red: 70 / 255,
                green: 130 / 255,
                blue: 240 / 255,
                alpha: 0.2)
                .cgColor
        case .tileLockedNeutral:
            alpha = 1.0
            layer.backgroundColor = UIColor(
                displayP3Red: 40 / 255,
                green: 80 / 255,
                blue: 130 / 255,
                alpha: 1)
                .cgColor
        case .tileLockedValid:
            alpha = 1.0
            layer.backgroundColor = UIColor.green.cgColor
        case .tileLockedInvalid:
            alpha = 1.0
            layer.backgroundColor = UIColor.red.cgColor
        case .tilePlaced:
            alpha = 1.0
            layer.backgroundColor = UIColor.blue.cgColor
        }
        
        switch letterState {
        case .none:
            letterLabel.isHidden = true
            valueLabel.isHidden = true
        case .some(letter: let letter, value: let value):
            letterLabel.text = String(bytes: [letter], encoding: .utf8)!
            valueLabel.text = value.description
            letterLabel.isHidden = false
            valueLabel.isHidden = false
        }
        
    }
    
}
