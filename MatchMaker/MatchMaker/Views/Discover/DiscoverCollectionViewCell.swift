//
//  DiscoverCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 03/08/21.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var GameTitleLabel: UILabel!
    @IBOutlet weak var PlaystationImage: UIImageView!
    @IBOutlet weak var XboxImage: UIImageView!
    @IBOutlet weak var PCImage: UIImageView!
    @IBOutlet weak var MobileImage: UIImageView!
    
    
    func setup(GameImage: UIImage, GameTitle: String, isPlaystation: Bool, isXbox: Bool, isPC: Bool, isMobile: Bool) {
        
        self.GameImage.image = GameImage
        self.GameImage.cornerRadius = 10
        self.GameTitleLabel.text = GameTitle
        
        if(isPlaystation) {
            PlaystationImage.image = UIImage(named: "Play_selected")
        }
        if(isXbox) {
            XboxImage.image = UIImage(named: "Xbox_selected")
        }
        if(isPC) {
            PCImage.image = UIImage(named: "PC_selected")
        }
        if(isMobile) {
            MobileImage.image = UIImage(named: "Mobile_selected")
        }
    }
    
}
