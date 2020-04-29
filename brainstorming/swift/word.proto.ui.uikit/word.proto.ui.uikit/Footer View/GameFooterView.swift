//
//  GameFooterView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameFooterView: UIView {
    
    // MARK: - Properties -
    
    let bottomBar = GameFooterViewBottomBar()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        addSubview(bottomBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
}
