//
//  TitleCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

//MARK: - TitleCell Class

class TitleCell: UICollectionViewCell {
    
    //MARK: TitleCell - Variables and Outlets Setup

    @IBOutlet weak var titleLabel: UILabel!
    static var titleFont: UIFont {
        AccessibilityManager.forCustomFont(forTextStyle: .body, forFontSize: 13, forFontWeight: .light)
    }
    
    //MARK: TitleCell - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDynamicTypes()
    }
    
    //MARK: TitleCell - Accessibility Features: Dynamic Types
    
    func setDynamicTypes(){
        titleLabel.font = Self.titleFont
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
