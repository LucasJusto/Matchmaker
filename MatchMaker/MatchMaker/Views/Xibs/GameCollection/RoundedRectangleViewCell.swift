//
//  RoundedRectangleViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

//MARK: - RoundedRectangleViewCell Class

class RoundedRectangleViewCell: UICollectionViewCell {
    
    //MARK: RoundedRectangleViewCell - Variables and Outlets Setup
    
    @IBOutlet weak var contentImage: UIImageView!
    
    //MARK: RoundedRectangleViewCell - View Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImage.accessibilityIgnoresInvertColors = true
        contentImage.isAccessibilityElement = true
        contentImage.accessibilityLabel = NSLocalizedString("ACroundedRectangleCell", comment: "This is the translation for 'ACroundedRectangleCell' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        contentImage.accessibilityHint = NSLocalizedString("ACroundedRectangleCellHint", comment: "This is the translation for 'ACroundedRectangleCellHint' at the Accessibility - Profile/Other Profile section of Localizable.strings")
    }
}
