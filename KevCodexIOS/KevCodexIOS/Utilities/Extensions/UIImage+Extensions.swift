//
//  UIImage+Extensions.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     
     Adds a gradient to an image depending on the colors you set
     
     - parameter colors: An array of colors that you want to add to the gradient.
     - parameter locations: An array of locations where you want to put the graient colors. Ranges from 0.0 to 1.0.
     - returns: An image with a gradient
     
     */
    func createGradient(with colors: [CGColor], at locations: [CGFloat]) -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colors = colors as CFArray
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else {
            return nil
        }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: size.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
