//
//  IconFactory.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/19/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

class IconFactory {
    
    private init() {}
    
    class func drawCrossIcon(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 44, height: 44),
                             resizing: ResizingBehavior = .aspectFit,
                             color: UIColor = .black) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 44, height: 44), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 44, y: resizedFrame.height / 44)
        
        let combinedShape = UIBezierPath()
        combinedShape.move(to: CGPoint(x: 16.4, y: 21.35))
        combinedShape.addLine(to: CGPoint(x: 1.03, y: 36.72))
        combinedShape.addCurve(to: CGPoint(x: 1.02, y: 41.68), controlPoint1: CGPoint(x: -0.34, y: 38.09), controlPoint2: CGPoint(x: -0.34, y: 40.31))
        combinedShape.addCurve(to: CGPoint(x: 5.98, y: 41.67), controlPoint1: CGPoint(x: 2.39, y: 43.04), controlPoint2: CGPoint(x: 4.61, y: 43.04))
        combinedShape.addLine(to: CGPoint(x: 21.35, y: 26.3))
        combinedShape.addLine(to: CGPoint(x: 36.72, y: 41.67))
        combinedShape.addCurve(to: CGPoint(x: 41.68, y: 41.68), controlPoint1: CGPoint(x: 38.09, y: 43.04), controlPoint2: CGPoint(x: 40.31, y: 43.04))
        combinedShape.addCurve(to: CGPoint(x: 41.67, y: 36.72), controlPoint1: CGPoint(x: 43.04, y: 40.31), controlPoint2: CGPoint(x: 43.04, y: 38.09))
        combinedShape.addLine(to: CGPoint(x: 26.3, y: 21.35))
        combinedShape.addLine(to: CGPoint(x: 41.67, y: 5.98))
        combinedShape.addCurve(to: CGPoint(x: 41.68, y: 1.02), controlPoint1: CGPoint(x: 43.04, y: 4.61), controlPoint2: CGPoint(x: 43.04, y: 2.39))
        combinedShape.addCurve(to: CGPoint(x: 36.72, y: 1.03), controlPoint1: CGPoint(x: 40.31, y: -0.34), controlPoint2: CGPoint(x: 38.09, y: -0.34))
        combinedShape.addLine(to: CGPoint(x: 21.35, y: 16.4))
        combinedShape.addLine(to: CGPoint(x: 5.98, y: 1.03))
        combinedShape.addCurve(to: CGPoint(x: 1.02, y: 1.02), controlPoint1: CGPoint(x: 4.61, y: -0.34), controlPoint2: CGPoint(x: 2.39, y: -0.34))
        combinedShape.addCurve(to: CGPoint(x: 1.03, y: 5.98), controlPoint1: CGPoint(x: -0.34, y: 2.39), controlPoint2: CGPoint(x: -0.34, y: 4.61))
        combinedShape.addLine(to: CGPoint(x: 16.4, y: 21.35))
        combinedShape.close()
        combinedShape.move(to: CGPoint(x: 16.4, y: 21.35))
        
        context.saveGState()
        context.translateBy(x: 0.98, y: -0)
        combinedShape.usesEvenOddFillRule = true
        color.setFill()
        combinedShape.fill()
        context.restoreGState()
        
        context.restoreGState()
    }
    
    class func imageOfCrossIcon(withSize size: CGSize = CGSize(width: 22, height: 22),
                                resizing: ResizingBehavior = .aspectFit,
                                color: UIColor = .black) -> UIImage {
        struct Cache {
            static var image: UIImage?
        }
        
        if let image = Cache.image {
            return image
        }
        
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawCrossIcon(frame: CGRect(origin: .zero, size: size), resizing: resizing, color: color)
        
        guard let imageContext = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure("Error getting image")
            return UIImage()
        }
        
        image = imageContext
        UIGraphicsEndImageContext()
        
        Cache.image = image
        
        return image
    }
    
    // MARK: - Resizing Behavior
    enum ResizingBehavior {
        /// The content is proportionally resized to fit into the target rectangle.
        case aspectFit
        /// The content is proportionally resized to completely fill the target rectangle.
        case aspectFill
        /// The content is stretched to match the entire target rectangle.
        case stretch
        /// The content is centered in the target rectangle, but it is NOT resized.
        case center
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
