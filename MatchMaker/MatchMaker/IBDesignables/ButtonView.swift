//
//  ButtonView.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 03/08/21.
//

import UIKit

@IBDesignable
class ButtonView: UIButton {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
}
