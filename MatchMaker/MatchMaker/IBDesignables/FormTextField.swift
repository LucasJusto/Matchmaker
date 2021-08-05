//
//  FormTextField.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 27/07/21.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {

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
