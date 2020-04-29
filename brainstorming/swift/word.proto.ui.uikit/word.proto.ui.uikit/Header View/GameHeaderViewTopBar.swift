//
//  GameHeaderViewTopBar.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderViewTopBar: UIView {
    
    // MARK: - Properties -
    
    private let backButton = SystemImageButton(name: "chevron.left.circle")
    private let quitButton = SystemImageButton(name: "xmark.circle")
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString.stylized(string: "50 Tiles Remain",
                                                           size: 18,
                                                           weight: .semibold)
        return label
    }()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(backButton)
        addSubview(quitButton)
        addSubview(label)
        
        backgroundColor = purpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomPadding: CGFloat = 10
        let usableHeight = frame.height - safeAreaInsets.top - bottomPadding
        let leading: CGFloat = directionalLayoutMargins.leading * 2
        backButton.frame = CGRect(x: leading,
                                            y: safeAreaInsets.top + usableHeight / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let trailing: CGFloat = directionalLayoutMargins.trailing * 2
        quitButton.frame = CGRect(x: frame.width - trailing - _imageViewSize,
                                            y: safeAreaInsets.top + usableHeight / 2 - _imageViewSize / 2,
                                            width: _imageViewSize,
                                            height: _imageViewSize)
        
        let usableLabelWidth = frame.width - backButton.frame.maxX * 2
        
        
        label.frame = CGRect(x: frame.width / 2 - usableLabelWidth / 2,
                             y: safeAreaInsets.top,
                             width: usableLabelWidth,
                             height: usableHeight)
        
    }
}
