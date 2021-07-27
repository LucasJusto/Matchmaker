//
//  OnboardingCollectionViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 23/07/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var onboardingImageView: UIImageView!
    
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    
    @IBOutlet weak var onboardingDescriptionLabel: UILabel!

    func setup(_ screen: OnboardingScreen) {
        
        onboardingImageView.image = screen.image
        onboardingTitleLabel.text = screen.title
        onboardingDescriptionLabel.text = screen.description
        
        onboardingImageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingImageView.heightAnchor.constraint(equalToConstant: CGFloat(screen.imageHeight)).isActive = true
        onboardingImageView.widthAnchor.constraint(equalToConstant: CGFloat(screen.imageWidth)).isActive = true
        let games = Games.buildGameArray()
        CKRepository.setOnboardingInfo(name: "Lucas Justo", nickname: "lolzinho", photo: nil, photoURL: nil,country: "Brasil", description: "af", languages: ["tanto faz é teste"], selectedPlatforms: [Platform.PC], selectedGames: [games[1], games[2]])
    }

}
