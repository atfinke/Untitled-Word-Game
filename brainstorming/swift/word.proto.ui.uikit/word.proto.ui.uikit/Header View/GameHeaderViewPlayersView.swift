//
//  GameHeaderViewPlayersView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderViewPlayersView: UIView {
    
    let playerViews: [GameHeaderViewPlayerStatusView]
    
    init(players: [String]) {
        playerViews = players.map { GameHeaderViewPlayerStatusView(player: $0) }
        super.init(frame: .zero)
        playerViews.forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index, view) in playerViews.enumerated() {
            view.frame = frameForPlayer(index: index)
        }
    }
    
    func frameForPlayer(index: Int) -> CGRect {
        let usableWidth = frame.width
            - directionalLayoutMargins.leading
            - directionalLayoutMargins.trailing
        
        let playerWidth = usableWidth / CGFloat(playerViews.count)
        return CGRect(x: directionalLayoutMargins.leading + CGFloat(index) * playerWidth,
                      y: 0,
                      width: playerWidth,
                      height: frame.height)
    }
    
}
