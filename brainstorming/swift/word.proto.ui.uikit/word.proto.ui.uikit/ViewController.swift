//
//  ViewController.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/20/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

let blueColor = UIColor(displayP3Red: 40 / 255, green: 80 / 255, blue: 128 / 255, alpha: 1)
let purpleColor = UIColor(displayP3Red: 70 / 255, green: 134 / 255, blue: 244 / 255, alpha: 1)
let _imageViewSize: CGFloat = 44

class ViewController: UIViewController {

    let headerView = GameHeaderView(players: ["Andrew", "Maxine", "Garrett"])
    let boardView = BoardView()
    let footerView = GameFooterView()
    let game = _Game()
    
    override func viewDidLoad() {
        view.addSubview(headerView)
        view.addSubview(footerView)
        view.addSubview(boardView)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            let m = self.game.move()
            DispatchQueue.main.async {
                self.boardView.update(to: self.game.board)
                
                self.headerView.topBar.label.attributedText = NSAttributedString.stylized(string: "\(self.game.tileBag.remainCount()) Tiles Remain",
                                                                          size: 18,
                                                                          weight: .semibold)
                
                if let m = m {
                    self.footerView.bottomBar.played(words: m.words)
                }
            }
        }
        
        view.backgroundColor = .white
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.frame = CGRect(x: 0,
                              y: 0,
                              width: view.frame.width,
                              height: 175)
        
        let height: CGFloat = 46 + view.safeAreaInsets.bottom
        footerView.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
        
        boardView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: view.frame.width, height: footerView.frame.minY - headerView.frame.maxY)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

