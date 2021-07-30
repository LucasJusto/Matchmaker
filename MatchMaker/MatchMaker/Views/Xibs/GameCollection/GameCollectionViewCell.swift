//
//  GameCollectionViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

//MARK: - GameCollectionViewCell Class

class GameCollectionViewCell: UICollectionViewCell {
    
    //MARK: GameCollectionViewCell - Variables and Outlets Setup
    
    @IBOutlet weak var contentImage: UIImageView!
    
    //MARK: GameCollectionViewCell - View Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImage.accessibilityIgnoresInvertColors = true
    }
}
