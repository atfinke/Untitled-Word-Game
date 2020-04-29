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

    let header = GameHeaderView(players: ["Andrew", "Maxine", "Garrett"])
    let footer = GameFooterView()
    
    override func viewDidLoad() {
        view.addSubview(header)
        view.addSubview(footer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        header.frame = CGRect(x: 0,
                              y: 0,
                              width: view.frame.width,
                              height: 400)
        
        let height: CGFloat = 46 + view.safeAreaInsets.bottom
        footer.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

