//
//  LanguageCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

class LanguageCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDynamicTypes()
    }
    
    func setDynamicTypes(){
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        let titleFont = UIFont.systemFont(ofSize: 13, weight: .light)
        
        let scaledTitleFont = bodyMetrics.scaledFont(for: titleFont)
        
        titleLabel.font = scaledTitleFont
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
