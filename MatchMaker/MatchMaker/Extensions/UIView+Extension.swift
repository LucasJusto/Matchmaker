//
//  UIView+Extension.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 23/07/21.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius } //se mudar para self NAO VAI FUNCIONAR.
        set { self.layer.cornerRadius = newValue}
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
