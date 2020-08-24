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
    
    func played(words: [[UInt8]]) {
        
        var mappedWords = [(String, Int)]()
        
        var score = 0
        for word in words {
            var wordScore = 0
            for letter in word {
                guard let value = TileBag.characterTileValues[letter] else { fatalError() }
                wordScore += value
                score += value
            }
            mappedWords.append((String(bytes: word, encoding: .utf8)!, wordScore))
        }
        
        mappedWords.sort { lhs, rhs -> Bool in
            lhs.1 > rhs.1
        }
        
        
        let size: CGFloat = 18
        let weight: UIFont.Weight = .semibold
        
        var strings = [NSAttributedString]()
        var images = [String]()
        for (index, (word, wordScore)) in mappedWords.enumerated() {
            let prefix = index == 0 ? "" : "+ "
            let attr: NSAttributedString = .stylized(string: prefix + word, size: size, weight: weight)
            strings.append(attr)
            images.append(wordScore.description + ".circle")
        }
        
        if words.count > 1 {
            let attr: NSAttributedString = .stylized(string: "=", size: size, weight: weight)
            strings.append(attr)
            images.append(score.description + ".circle")
        }
        
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        imageView.image = AttributedStringSystemImageMixer.mix(strings: strings,
                                                               systemImages: images,
                                                               config: config,
                                                               imageSize: CGSize(width: 22, height: 22),
                                                               maxSize: imageView.frame.size)
        
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
            
            
        }
    }
}
