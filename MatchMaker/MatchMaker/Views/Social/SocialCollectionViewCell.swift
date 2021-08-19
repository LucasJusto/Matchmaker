//
//  DiscoverCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 03/08/21.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell {
    
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
        
        playstationImage.isHidden = true
        xboxImage.isHidden = true
        pcImage.isHidden = true
        mobileImage.isHidden = true
        
        if(isPlaystation) {
            playstationImage.isHidden = false
        }
        if(isXbox) {
            xboxImage.isHidden = false
        }
        if(isPC) {
            pcImage.isHidden = false
        }
        if(isMobile) {
            mobileImage.isHidden = false
        }
    }
    
}
