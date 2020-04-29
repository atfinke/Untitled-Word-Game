//
//  GameHeaderView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderView: UIView {
    
    private let topBar = GameHeaderViewTopBar()
    private let playersView: GameHeaderViewPlayersView
    private let statusBar = GameHeaderViewStatusBar()
    private let playersTurnView = GameHeaderViewPlayersTurnView()
    
    let bottomView = UIView()
    
    var playerTurnIndex = 0
    
    init(players: [String]) {
        playersView = GameHeaderViewPlayersView(players: players)
        super.init(frame: .zero)
        
        addSubview(bottomView)
        addSubview(topBar)
        addSubview(playersTurnView)
        addSubview(playersView)
        addSubview(statusBar)
        backgroundColor = purpleColor
        
        playersTurnView.color = blueColor
        bottomView.backgroundColor = .white
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.setNeedsLayout()
//            UIView.animate(withDuration: 1,
//                           delay: 0,
//                           usingSpringWithDamping: 0.80,
//                           initialSpringVelocity: 0.25,
//                           options: .beginFromCurrentState,
//                           animations: {
//                            self.playerTurnIndex += 1
//
//                            let color = UIColor.darkGray
//                            self.playersTurnView.color = color
//                            self.statusBar.layer.backgroundColor = color.cgColor
//
//                            self.layoutIfNeeded()
//
//
//
//
//
//            },
//                           completion: nil)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topBar.frame = CGRect(x: 0,
                              y: 0,
                              width: frame.width,
                              height: 56 + safeAreaInsets.top)
        playersView.frame = CGRect(x: 0,
                                   y: topBar.frame.maxY,
                                   width: frame.width,
                                   height: 60)
        statusBar.frame = CGRect(x: 0,
                                 y: playersView.frame.maxY,
                                 width: frame.width,
                                 height: 32)
        
        playersTurnView.frame = playersView
            .frameForPlayer(index: playerTurnIndex)
            .offsetBy(dx: 0, dy: playersView.frame.minY)
        
        
        bottomView.frame = CGRect(x: 0,
                                  y: playersView.frame.maxY,
                                  width: frame.width,
                                  height: frame.height)
    }
}
