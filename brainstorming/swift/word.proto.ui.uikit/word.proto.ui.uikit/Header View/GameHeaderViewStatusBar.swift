//
//  GameHeaderViewStatusBar.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderViewStatusBar: UIView {
    
    // MARK: - Properties -
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        backgroundColor = blueColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let _setup = imageView.frame == .zero
        imageView.frame = bounds
        
        if _setup {
            let size: CGFloat = 14
            let weight: UIFont.Weight = .medium
            let strings: [NSAttributedString] = [
                .stylized(string: "Play a word worth at least", size: size, weight: weight),
                .stylized(string: "or", size: size, weight: weight),
                .stylized(string: "the board", size: size, weight: weight),
            ]
            let images = [
                "4.circle",
                "arrowtriangle.up.square.fill"
            ]
            let config = UIImage.SymbolConfiguration(weight: .regular)
            imageView.image = AttributedStringSystemImageMixer.mix(strings: strings,
                                                                   systemImages: images,
                                                                   config: config,
                                                                   imageSize: CGSize(width: 18, height: 18),
                                                                   maxSize: imageView.frame.size)
            
        }
    }
    
    
}
