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
    }
}
