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
    
    @IBOutlet weak var behaviourRatingView: ProfileRatingView!
    @IBOutlet weak var skillsRatingView: ProfileRatingView!
    @IBOutlet weak var platformsView: SmallLabeledImageCollectionView!
    @IBOutlet weak var languagesView: TitleCollectionView!
    @IBOutlet weak var gameCollectionView: RoundedRectangleCollectionView!
    
    var customPicker: ImagePickerManager = ImagePickerManager()
    
    private var user: User?
    
    var marinaGames: [Game] = Games.buildGameArray()
    
    //MARK: ProfileViewController - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAvatarView.delegate = self
            
        //2 maneira de capturar a imagem do usuario, mas usando closures
//        userAvatarView.didChooseImage = { [weak self] in
//            guard let self = self else { return }
//            ImagePickerManager().pickImage(self) { image in
//                DispatchQueue.main.async {
//                    self.userAvatarView.contentImage.image = image
//                    self.userAvatarView.contentImage.contentMode = .scaleAspectFill
//                }
//            }
//        }
        
//        CKRepository.setOnboardingInfo(name: "Marina de Pazzi", nickname: "Prolene", photoURL: nil, location: Locations.brazil, description: "fala fellas, voce que curte um cszinho, bora fazer um projetinho na mansao arromba", languages: [Languages.english, Languages.portuguese, Languages.russian], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: [marinaGames[1], marinaGames[2]])
        
        setupUserProfile()

        backgroundCoverImage.accessibilityIgnoresInvertColors = true
        dynamicTypesFontConfig()
        
    }
    
    private func setupUserProfile() {
        user = User(id: "teste", name: "Marina de Pazzi", nickname: "Prolene", photoURL: nil, location: Locations.brazil, description: "fala fellas, voce que curte um cszinho, bora fazer um projetinho na mansao arromba", behaviourRate: 5.0, skillRate: 5.0, languages: [Languages.english, Languages.portuguese, Languages.russian, Languages.german], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: [marinaGames[1], marinaGames[2]])
        
        guard let unwrappedUser = user else { return }
        
        userProfileNameLabel.text = unwrappedUser.name
        userProfileGamertagLabel.text = "@" + unwrappedUser.nickname
        userProfileBioLabel.text = unwrappedUser.description
        
        behaviourRatingView.ratingLabel.text = String(unwrappedUser.behaviourRate)
        behaviourRatingView.categoryOfRatingLabel.text = NSLocalizedString("UserBehaviour", comment: "This is the key for 'behaviour' translation")
        behaviourRatingView.amountOfReviewsLabel.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        skillsRatingView.ratingLabel.text = String(unwrappedUser.skillRate)
        skillsRatingView.categoryOfRatingLabel.text = NSLocalizedString("UserSkills", comment: "This is the key for 'skills' translation")
        skillsRatingView.amountOfReviewsLabel.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        
        platformsView.smallLabeledImageModels = unwrappedUser.selectedPlatforms
        languagesView.titleModels = unwrappedUser.languages
        gameCollectionView.RoundedRectangleImageModels = unwrappedUser.selectedGames
    }
    
    //MARK: ProfileViewController - Accessibility Features: Dynamic Types
    
    func dynamicTypesFontConfig() {
        let scaledUserProfileNameFont = AccessibilityManager
            .forCustomFont(forTextStyle: .headline, forFontSize: 22, forFontWeight: .bold)
        let scaledUserGamertagFont = AccessibilityManager
            .forCustomFont(forTextStyle: .callout, forFontSize: 9, forFontWeight: .light)
        let scaledProfileBioFont = AccessibilityManager
            .forCustomFont(forTextStyle: .body, forFontSize: 13, forFontWeight: .light)
        let scaledSectionTitle1Font = AccessibilityManager
            .forCustomFont(forTextStyle: .title1, forFontSize: 22, forFontWeight: .bold)
        
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
    
    @IBAction func didTapEditingButton(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfile" {
            let navViewController = segue.destination as! UINavigationController
            
            let destination = navViewController.topViewController as! EditingProfileViewController
            
            destination.user = self.user
        }
    }
}

//MARK: - ProfileViewController - Setting User Profile Picture

extension ProfileViewController: UserAvatarViewDelegate {
    func didChooseImage() {
        customPicker.pickImage(self) { [unowned self] image, url in
            DispatchQueue.main.async {
                print(url)
                self.userAvatarView.imageURL = url
                self.userAvatarView.contentImage.image = image
                self.userAvatarView.contentImage.contentMode = .scaleAspectFill
            }
        }
    }
}
