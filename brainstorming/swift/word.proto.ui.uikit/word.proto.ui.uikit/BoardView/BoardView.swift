//
//  BoardView.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 5/3/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //        scrollView.backgroundColor = UIColor.lightGray
        return scrollView
    }()
    
    let _contentView = UIView()
    
    private var tiles = [BoardPosition: TileView]()
    
    
    // MARK: - Initialization -
    
    init() {
        super.init(frame: .zero)
        addSubview(scrollView)
        _contentView.frame = CGRect.zero
        _contentView.backgroundColor = UIColor.lightGray
        scrollView.addSubview(_contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(to board: Board) {
        var updatedPositions = Set<BoardPosition>()
        for (position, letter) in board.placements {
            let tileView: TileView
            if let existing = tiles[position] {
                tileView = existing
            } else {
                tileView = TileView()
                tiles[position] = tileView
                scrollView.addSubview(tileView)
            }
            tileView.letterState = .some(letter: letter, value: 1)
            tileView.state = .tileLockedNeutral
            updatedPositions.insert(position)
        }
        for position in board.anchors() {
            let tileView: TileView
            if let existing = tiles[position] {
                tileView = existing
            } else {
                tileView = TileView()
                tiles[position] = tileView
                scrollView.addSubview(tileView)
            }
            tileView.letterState = .none
            tileView.state = .open
            updatedPositions.insert(position)
        }
        for position in tiles.keys.filter({ !updatedPositions.contains($0) }) {
            tiles[position]?.letterState = .none
            tiles[position]?.state = .hidden
        }
        
        setNeedsLayout()
        tiles.values.forEach { $0.setNeedsLayout() }
        UIView.animate(withDuration: 1.0) {
            self.tiles.values.forEach { $0.layoutIfNeeded() }
            self.layoutIfNeeded()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tileSize: CGFloat = 40
        let tilePadding: CGFloat = 10
        let tileFullSize = tileSize + tilePadding
        
        
        scrollView.frame = bounds
        
        var minX: Int = 0
        var maxY: Int = 0
        let visibleTiles = tiles.filter { $0.value.state != .hidden }
        if let firstTile = visibleTiles.first {
            minX = firstTile.key.x
            var minY = firstTile.key.x
            var maxX: Int = firstTile.key.x
            maxY = firstTile.key.x
            
            for position in visibleTiles.keys {
                minX = min(minX, position.x)
                maxX = max(maxX, position.x)
                minY = min(minY, position.y)
                maxY = max(maxY, position.y)
            }
            
            scrollView.contentSize = CGSize(
                width: CGFloat(maxX - minX + 1) * tileFullSize,
                height: CGFloat(maxY - minY + 1) * tileFullSize)
            _contentView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
            scrollView.sendSubviewToBack(_contentView)
        } else {
            scrollView.contentSize = bounds.size
        }
        
        let xOffset = scrollView.bounds.width > scrollView.contentSize.width ? (scrollView.bounds.width - scrollView.contentSize.width) / 2 : 0
        let yOffset = scrollView.bounds.height > scrollView.contentSize.height ? (scrollView.bounds.height - scrollView.contentSize.height) / 2 : 0
        
        defer {
//            UIView.performWithoutAnimation {
//                self.scrollView.contentOffset = CGPoint(x: -xOffset, y: -yOffset)
//            }
        }
        
        
//        isUserInteractionEnabled = false
        
        
        let scrollViewCenter = scrollView.contentSize.center
        let tilesCenter = scrollViewCenter - scrollViewCenter - tileSize / 2
        for (position, tile) in tiles {
            
            if tile.frame == .zero {
                UIView.performWithoutAnimation {
                    tile.frame = CGRect(
                    x: 0 + CGFloat(position.x - minX) * tileFullSize,
                    y: 0 + CGFloat(-position.y + maxY) * tileFullSize,
                    width: tileSize,
                    height: tileSize)
                }
            } else {
                tile.frame = CGRect(
                x: 0 + CGFloat(position.x - minX) * tileFullSize,
                y: 0 + CGFloat(-position.y + maxY) * tileFullSize,
                width: tileSize,
                height: tileSize)
            }
            
            
        }
        
        
        
    }
    
    
}
