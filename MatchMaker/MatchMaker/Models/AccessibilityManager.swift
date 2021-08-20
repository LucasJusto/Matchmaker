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
    
    /**
     Sets up a custom font for fixed titles of size 24 and weight .bold
     
     - Parameters: Void
     
     - returns: the scaled font based on the given params
     */
    static func forTitle1() -> UIFont {
        let headlineMetrics = UIFontMetrics.init(forTextStyle: .title1)
        let font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        return headlineMetrics.scaledFont(for: font)
    }
    
    /**
     Sets up a custom font for fixed headlines of size 22 and weight .bold
     
     - Parameters: Void
     
     - returns: the scaled font based on the given params
     */
    static func forHeadline() -> UIFont {
        let headlineMetrics = UIFontMetrics.init(forTextStyle: .headline)
        let font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return headlineMetrics.scaledFont(for: font)
    }
    
    /**
     Sets up a custom font for fixed callouts of size 9 and weight .light
     
     - Parameters: Void
     
     - returns: the scaled font based on the given params
     */
    static func forCallout() -> UIFont {
        let headlineMetrics = UIFontMetrics.init(forTextStyle: .callout)
        let font = UIFont.systemFont(ofSize: 9, weight: .light)
        
        return headlineMetrics.scaledFont(for: font)
    }
    
    /**
     Sets up a custom font for fixed titles of size 13 and weight .light
     
     - Parameters: Void
     
     - returns: the scaled font based on the given params
     */
    static func forBody() -> UIFont {
        let headlineMetrics = UIFontMetrics.init(forTextStyle: .body)
        let font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        return headlineMetrics.scaledFont(for: font)
    }
}
