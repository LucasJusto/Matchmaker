//
//  PlatformCollectionViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

//MARK: - PlatformCollectionViewCell Class

class PlatformCollectionViewCell: UICollectionViewCell {
    
    //MARK: PlatformCollectionViewCell - Variables and Outlets Setup

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: PlatformCollectionViewCell - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDynamicTypes()
    }
    
    //MARK: PlatformCollectionViewCell - Accessibility Features: Dynamic Types
    
    func setDynamicTypes(){
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        let titleFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let scaledTitleFont = bodyMetrics.scaledFont(for: titleFont)
        
        titleLabel.font = scaledTitleFont
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
