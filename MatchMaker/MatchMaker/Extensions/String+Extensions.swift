//
//  String+Extensions.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 27/07/21.
//

import UIKit

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
