//
//  GameHeaderViewPlayerStatusView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderViewPlayerStatusView: UIView {
    
    // MARK: - Properties -
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    private let tilesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    // MARK: - Initalization -
    
    init(player: String) {
        super.init(frame: .zero)
        playerNameLabel.attributedText = NSAttributedString.stylized(string: player,
                                                                     size: 14,
                                                                     weight: .semibold)
        tilesLabel.attributedText = NSAttributedString.stylized(string: "7 | 7",
                                                                size: 16,
                                                                weight: .semibold)
        addSubview(playerNameLabel)
        addSubview(tilesLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indent: CGFloat = 6
        let tilesLabelSize: CGFloat = 24
        playerNameLabel.frame = CGRect(x: 0,
                                       y: indent,
                                       width: frame.width,
                                       height: frame.height - tilesLabelSize - indent * 2)
        tilesLabel.frame = CGRect(x: 0,
                                  y: frame.height - tilesLabelSize - indent,
                                  width: frame.width,
                                  height: tilesLabelSize)
    }
}
