//
//  DiscoverCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 03/08/21.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var playstationImage: UIImageView!
    @IBOutlet weak var xboxImage: UIImageView!
    @IBOutlet weak var pcImage: UIImageView!
    @IBOutlet weak var mobileImage: UIImageView!
    
    
    func setup(GameImage: UIImage, GameTitle: String, isPlaystation: Bool, isXbox: Bool, isPC: Bool, isMobile: Bool) {
        
        self.gameImage.image = GameImage
        self.gameImage.cornerRadius = 10
        self.gameTitleLabel.text = GameTitle
        
        if(isPlaystation) {
            playstationImage.image = UIImage(named: "Play_selected")
        }
        if(isXbox) {
            xboxImage.image = UIImage(named: "Xbox_selected")
        }
        if(isPC) {
            pcImage.image = UIImage(named: "PC_selected")
        }
        if(isMobile) {
            mobileImage.image = UIImage(named: "Mobile_selected")
        }
    }
    
}
