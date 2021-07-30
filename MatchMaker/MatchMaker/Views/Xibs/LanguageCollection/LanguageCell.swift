//
//  LanguageCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

//MARK: - LanguageCell Class

class LanguageCell: UICollectionViewCell {
    
    //MARK: LanguageCell - Variables and Outlets Setup

    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: LanguageCell - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDynamicTypes()
    }
    
    //MARK: LanguageCell - Accessibility Features: Dynamic Types
    
    func setDynamicTypes(){
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        let titleFont = UIFont.systemFont(ofSize: 13, weight: .light)
        
        let scaledTitleFont = bodyMetrics.scaledFont(for: titleFont)
        
        titleLabel.font = scaledTitleFont
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
