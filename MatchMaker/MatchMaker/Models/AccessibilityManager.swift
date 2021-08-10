//
//  AccessibilityManager.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 03/08/21.
//

import Foundation
import UIKit

//MARK: - AccessibilityManager Class
/**
 AccessibilityManager is a class created to abstract and facilitate the process of implementing DynamicTypes to our project. Instead manually creating UIFontMetrics and Scalable fonts, this class abstracts this setup and returns a scalable font.
 */
class AccessibilityManager {
    
    /**
     Sets up a custom font when enabling DynamicTypes
     
     - Parameters:
        - textStyle: Style of the font to be scaled
        - fontSize: Size of the font to be scaled
        - fontWeight: The Weight of font to be scaled
     
     - returns: the scaled font based on the given params
     */
    static func forCustomFont(forTextStyle textStyle: UIFont.TextStyle, forFontSize fontSize: CGFloat, forFontWeight fontWeight: UIFont.Weight) -> UIFont {
        let fontMetrics = UIFontMetrics.init(forTextStyle: textStyle)
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
        return fontMetrics.scaledFont(for: font)
    }
}
