//
//  ProfileViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 26/07/21.
//

import UIKit

//MARK: - ProfileViewController Class

class ProfileViewController: UIViewController {
    
    //MARK: ProfileViewController - Variables and Outlets Setup
    
    @IBOutlet weak var backgroundCoverImage: UIImageView!
    
    @IBOutlet weak var userAvatarView: UserAvatarView!
    
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var userProfileGamertagLabel: UILabel!
    @IBOutlet weak var userProfileBioLabel: UILabel!
    
    @IBOutlet weak var ratingsTitleLabel: UILabel!
    @IBOutlet weak var platformsTitleLabel: UILabel!
    @IBOutlet weak var languagesTitleLabel: UILabel!
    @IBOutlet weak var gamesTitleLabel: UILabel!
    
    //MARK: ProfileViewController - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundCoverImage.accessibilityIgnoresInvertColors = true
        dynamicTypesFontConfig()
        
        userAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
    }
    
    //MARK: ProfileViewController - Accessibility Features: Dynamic Types
    
    func dynamicTypesFontConfig() {
        let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
        let calloutMetrics = UIFontMetrics(forTextStyle: .callout)
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        let title1Metrics = UIFontMetrics(forTextStyle: .title1)
        
        let userProfileNameFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let userGamertagFont = UIFont.systemFont(ofSize: 9, weight: .light)
        let userProfileBioFont = UIFont.systemFont(ofSize: 13, weight: .light)
        let sectionTitlesFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        let scaledUserProfileNameFont = headlineMetrics.scaledFont(for: userProfileNameFont)
        let scaledUserGamertagFont = calloutMetrics.scaledFont(for: userGamertagFont)
        let scaledProfileBioFont = bodyMetrics.scaledFont(for: userProfileBioFont)
        let scaledSectionTitle1Font = title1Metrics.scaledFont(for: sectionTitlesFont)
        
        userProfileNameLabel.font = scaledUserProfileNameFont
        userProfileNameLabel.adjustsFontForContentSizeCategory = true
        
        userProfileGamertagLabel.font = scaledUserGamertagFont
        userProfileGamertagLabel.adjustsFontForContentSizeCategory = true
        
        userProfileBioLabel.font = scaledProfileBioFont
        userProfileBioLabel.adjustsFontForContentSizeCategory = true
        
        ratingsTitleLabel.font = scaledSectionTitle1Font
        ratingsTitleLabel.adjustsFontForContentSizeCategory = true
        
        platformsTitleLabel.font = scaledSectionTitle1Font
        platformsTitleLabel.adjustsFontForContentSizeCategory = true
        
        languagesTitleLabel.font = scaledSectionTitle1Font
        languagesTitleLabel.adjustsFontForContentSizeCategory = true
        
        gamesTitleLabel.font = scaledSectionTitle1Font
        gamesTitleLabel.adjustsFontForContentSizeCategory = true
    }
    
    @objc func chooseImage() {
        ImagePickerManager().pickImage(self) { image in
            DispatchQueue.main.async {
                self.userAvatarView.contentImage.image = image
                self.userAvatarView.contentImage.contentMode = .scaleAspectFill
            }
        }
    }
}
