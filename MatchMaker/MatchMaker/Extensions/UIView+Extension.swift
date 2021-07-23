//
//  UIView+Extension.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 23/07/21.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set { self.layer.cornerRadius = newValue}
    }
}
