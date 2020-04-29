//
//  GameFooterViewBottomBar.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameFooterViewBottomBar: UIView {
    
    // MARK: - Properties -
    
    private let pickUpButton = SystemImageButton(name: "arrowtriangle.up.square.fill")
    private let playButton = SystemImageButton(name: "play.circle.fill")
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(pickUpButton)
        addSubview(playButton)
        addSubview(imageView)
        
        backgroundColor = purpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        let usableHeight = frame.height - safeAreaInsets.bottom
        
        let leading: CGFloat = directionalLayoutMargins.leading * 2
        pickUpButton.frame = CGRect(x: leading,
                                    y: usableHeight / 2 - _imageViewSize / 2,
                                    width: _imageViewSize,
                                    height: _imageViewSize)
        
        let trailing: CGFloat = directionalLayoutMargins.trailing * 2
        playButton.frame = CGRect(x: frame.width - trailing - _imageViewSize,
                                  y: usableHeight / 2 - _imageViewSize / 2,
                                  width: _imageViewSize,
                                  height: _imageViewSize)
        
        
        let usableLabelWidth = frame.width - pickUpButton.frame.maxX * 2
        
        let _setImage = imageView.frame.size == .zero
        
        
        imageView.frame = CGRect(x: frame.width / 2 - usableLabelWidth / 2,
                                 y: 0,
                                 width: usableLabelWidth,
                                 height: usableHeight)
        //        imageView.backgroundColor = .black
        
        if _setImage {
            let size: CGFloat = 18
            let weight: UIFont.Weight = .semibold
            let strings: [NSAttributedString] = [
                .stylized(string: "art", size: size, weight: weight),
                .stylized(string: "+ ra", size: size, weight: weight),
                .stylized(string: "+ ti", size: size, weight: weight),
                .stylized(string: "=", size: size, weight: weight),
            ]
            let images = [
                "3.circle",
                "2.circle",
                "2.circle",
                "7.circle"
            ]
            let config = UIImage.SymbolConfiguration(weight: .semibold)
            imageView.image = AttributedStringSystemImageMixer.mix(strings: strings,
                                                                   systemImages: images,
                                                                   config: config,
                                                                   imageSize: CGSize(width: 22, height: 22),
                                                                   maxSize: imageView.frame.size)
            
        }
    }
}
