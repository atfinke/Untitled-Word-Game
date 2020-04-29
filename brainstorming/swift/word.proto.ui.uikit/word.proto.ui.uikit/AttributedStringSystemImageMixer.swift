//
//  AttributedStringSystemImageMixer.swift
//  word.proto.ui.uikit
//
//  Created by Andrew Finke on 4/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit

class AttributedStringSystemImageMixer {
    
    // MARK: - Properties -
    
    private static let imagePadding: CGFloat = 5.0
    
    // MARK: - Helpers -
    
    static func mix(strings: [NSAttributedString], systemImages: [String], config: UIImage.Configuration, imageSize: CGSize, maxSize: CGSize) -> UIImage {
        var stringRenderPoints = [CGPoint]()
        
        let images = systemImages.map { systemName -> UIImage in
            guard let image = UIImage(systemName: systemName, withConfiguration: config) else { fatalError() }
            return image.withTintColor(.white)
        }
        var imageRenderRects = [CGRect]()
        
        var startX: CGFloat = 0
        for (index, string) in strings.enumerated() {
            stringRenderPoints.append(CGPoint(x: startX, y: maxSize.height / 4))
            let rect = string.boundingRect(with: .infinite, options: [], context: nil)
            startX += rect.size.width
            
            if index < images.count {
                let rect = CGRect(origin: CGPoint(x: startX + imagePadding, y: maxSize.height / 4), size: imageSize)
                imageRenderRects.append(rect)
                startX += imageSize.width + imagePadding * 2
            }
        }
        
        // todo: logic for making sure string fits
        
        let format = UIGraphicsImageRendererFormat()
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: startX, height: maxSize.height), format: format)
        return renderer.image { context in
            for (index, point) in stringRenderPoints.enumerated() {
                strings[index].draw(at: point)
            }
            for (index, rect) in imageRenderRects.enumerated() {
                images[index].draw(in: rect)
            }
        }
    }
    
    
}
