//
//  SmallLabeledImageCollectionViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

//MARK: - SmallLabeledImageCollectionViewCell Class

class SmallLabeledImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: SmallLabeledImageCollectionViewCell - Variables and Outlets Setup

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    static var titleFont: UIFont {
        AccessibilityManager.forCustomFont(forTextStyle: .body, forFontSize: 13, forFontWeight: .regular)
    }
    
    //MARK: SmallLabeledImageCollectionViewCell - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDynamicTypes()
    }
    
    //MARK: SmallLabeledImageCollectionViewCell - Accessibility Features: Dynamic Types
    
    func setDynamicTypes(){
        titleLabel.font = Self.titleFont
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
