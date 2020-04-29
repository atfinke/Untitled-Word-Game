//
//  SystemImageButton.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class SystemImageButton: UIButton {
    
    // MARK: - Initalization -
    
    init(name: String, color: UIColor = .white) {
        guard let image = UIImage(systemName: name) else { fatalError() }
        super.init(frame: .zero)
        tintColor = color
        setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
