//
//  GameHeaderViewPlayersTurnView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class GameHeaderViewPlayersTurnView: UIView {
    
    // MARK: - Properties -
    
    var color: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Initalization -
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = frame
        let radius: CGFloat = rect.width / 3 / 4
        let topWidth: CGFloat = rect.width / 3 * 2
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2,
                              y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2 + topWidth / 2,
                                 y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width / 2 + topWidth / 2,
                                        y: radius),
                    radius: radius,
                    startAngle: -CGFloat.pi / 2,
                    endAngle: 0,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width / 2 + topWidth / 2 + radius,
                                 y: rect.height - radius))
        path.addArc(withCenter: CGPoint(x: rect.width / 2 + topWidth / 2 + radius * 2,
                                        y: rect.height - radius),
                    radius: radius,
                    startAngle: -CGFloat.pi,
                    endAngle: -CGFloat.pi / 2 * 3,
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addArc(withCenter: CGPoint(x: 0,
                                        y: rect.height - radius),
                    radius: radius,
                    startAngle: -CGFloat.pi / 2 * 3,
                    endAngle: 0,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: radius, y: radius))
        path.addArc(withCenter: CGPoint(x: radius * 2,
                                        y: radius),
                    radius: radius,
                    startAngle: -CGFloat.pi,
                    endAngle: -CGFloat.pi / 2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width / 2,
                                 y: 0))
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
    }
}
