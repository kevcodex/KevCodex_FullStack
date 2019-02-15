//
//  CustomTextView.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/14/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextView: UITextView {
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = borderRadius
        }
    }
}
