//
//  GameCollectionViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImage.accessibilityIgnoresInvertColors = true
    }
}
