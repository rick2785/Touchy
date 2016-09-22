//
//  RoundedOutlineView.swift
//  Touchy
//
//  Created by Rickey Hrabowskie on 9/22/16.
//  Copyright © 2016 Rickey Hrabowskie. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedOutlineButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }

    override func prepareForInterfaceBuilder() {
        setupView()
    }
}
