//
//  AccessibilityManager.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 03/08/21.
//

import Foundation
import UIKit

//MARK: - AccessibilityManager Class

class AccessibilityManager {
    
    /**
    - Summary: this function returns a scaled font to be applied when using DynamicTypes for accessibility. This function receives three params in order to scale a custom font.
    params:
    - Parameters:
     - textStyle: Style of the font to be scaled | *UIFont.TextStyle*
     - fontSize: Size of the font to be scaled | *CGFloat*
     - fontWeight: The Weight of font to be scaled | *UIFont.Weight*
    
    - returns: the scaled font based on the given params
     */
    static func forCustomFont(forTextStyle textStyle: UIFont.TextStyle, forFontSize fontSize: CGFloat, forFontWeight fontWeight: UIFont.Weight) -> UIFont {
    
        let fontMetrics = UIFontMetrics.init(forTextStyle: textStyle)
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
        return fontMetrics.scaledFont(for: font)
    }
}
