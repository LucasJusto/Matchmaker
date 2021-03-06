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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundCoverImage: UIImageView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
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
    
    @IBOutlet weak var backgroundImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundImageHeightConstraint: NSLayoutConstraint!
    
    var customPicker: ImagePickerManager = ImagePickerManager()
    
    private var user: User?
        
    //MARK: ProfileViewController - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarView.delegate = self
        scrollView.delegate = self
        
        user = CKRepository.user
                
        setupUserProfile()
        
        backgroundCoverImage.accessibilityIgnoresInvertColors = true
        
        setupAccessibiltyFeatures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = CKRepository.user
        setupUserProfile()
    }
    
    private func setupUserProfile() {
        guard let unwrappedUser = user else { return }
        
        //User info
        userProfileNameLabel.text = unwrappedUser.name
        userProfileGamertagLabel.text = "@" + unwrappedUser.nickname
        userProfileBioLabel.text = unwrappedUser.description
        
        if let avatar = getAvatar(url: unwrappedUser.photoURL) {
            userAvatarView.contentImage.image = avatar
        }
        
        //Screen titles
        ratingsTitleLabel.text = NSLocalizedString("Ratings", comment: "This is the translation for 'Ratings' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        platformsTitleLabel.text = NSLocalizedString("Platforms", comment: "This is the translation for 'Platforms' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        languagesTitleLabel.text = NSLocalizedString("Languages", comment: "This is the translation for 'Languages' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        gamesTitleLabel.text = NSLocalizedString("UserGames", comment: "This is the translation for 'Your Games' at the UserProfile (Profile Tab) section of Localizable.strings")
        
        //User profile ratings
        behaviourRatingView.ratingLabel.text = String(unwrappedUser.behaviourRate)
        behaviourRatingView.categoryOfRatingLabel.text = NSLocalizedString("UserBehaviour", comment: "This is the translation for 'Behaviour' at the UserProfile (Profile Tab) section of Localizable.strings")
        behaviourRatingView.amountOfReviewsLabel.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the translation for 'Reviews' at the UserProfile (Profile Tab) section of Localizable.strings")
        
        skillsRatingView.ratingLabel.text = String(unwrappedUser.skillRate)
        skillsRatingView.categoryOfRatingLabel.text = NSLocalizedString("UserSkills", comment: "This is the translation for 'Skills' at the UserProfile (Profile Tab) section of Localizable.strings")
        skillsRatingView.amountOfReviewsLabel.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the translation for 'Reviews' at the UserProfile (Profile Tab) section of Localizable.strings")
        
        //user game details 
        platformsView.smallLabeledImageModels = unwrappedUser.selectedPlatforms
        languagesView.titleModels = unwrappedUser.languages
        gameCollectionView.roundedRectangleImageModels = unwrappedUser.selectedGames
        
        gameCollectionView.delegate = self
    }
    
    func getAvatar(url: URL?) -> UIImage? {
        
        if let url = url,
           let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        
        return UIImage(named: "profile_default")
    }
    
    //MARK: ProfileViewController - Accessibility Features: Dynamic Types
    
    func setupAccessibiltyFeatures() {
        guard let unwrappedUser = user else { return }
        
        //Voice Over - user profile
        userProfileNameLabel.accessibilityLabel = NSLocalizedString("ACuserName", comment: "This is the translation for 'ACuserName' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileNameLabel.accessibilityValue = unwrappedUser.name
        
        userProfileGamertagLabel.accessibilityLabel = NSLocalizedString("ACuserGamertag", comment: "This is the translation for 'ACuserGamertag' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileGamertagLabel.accessibilityValue = unwrappedUser.nickname
            
        userProfileBioLabel.accessibilityLabel = NSLocalizedString("ACuserBio", comment: "This is the translation for 'ACuserBio' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileBioLabel.accessibilityValue = unwrappedUser.description
        
        //voice over - screen setup
        editProfileButton.accessibilityLabel = NSLocalizedString("ACeditProfileButton", comment: "This is the translation for 'ACeditProfileButton' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        editProfileButton.accessibilityHint = NSLocalizedString("ACeditProfileButtonHint", comment: "This is the translation for 'ACeditProfileButtonHint' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        
        ratingsTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenRatingSection", comment: "This is the translation for 'ACscreenRatingSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //ratingsTitleLabel.accessibilityValue = NSLocalizedString("Ratings", comment: "This is the translation for 'Ratings' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        //behaviour rating grade
        behaviourRatingView.ratingLabel.accessibilityLabel = NSLocalizedString("ACratingsResult", comment: "This is the translation for 'ACratingsResult' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        behaviourRatingView.ratingLabel.accessibilityValue = "\(unwrappedUser.behaviourRate)"
        
        //behaviour label category
        behaviourRatingView.categoryOfRatingLabel.accessibilityLabel = NSLocalizedString("ACratingsCategory", comment: "This is the translation for 'ACratingsCategory' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        behaviourRatingView.categoryOfRatingLabel.accessibilityValue = NSLocalizedString("UserBehaviour", comment: "This is the translation for 'UserBehaviour' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        
        //skill rating grade
        skillsRatingView.ratingLabel.accessibilityLabel = NSLocalizedString("ACratingsResult", comment: "This is the translation for 'ACratingsResult' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        skillsRatingView.ratingLabel.accessibilityValue = "\(unwrappedUser.skillRate)"
        
        //skill label category
        skillsRatingView.categoryOfRatingLabel.accessibilityLabel = NSLocalizedString("ACratingsCategory", comment: "This is the translation for 'ACratingsCategory' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        skillsRatingView.categoryOfRatingLabel.accessibilityValue = NSLocalizedString("UserSkills", comment: "This is the translation for 'UserSkills' at the Accessibility - Profile/Other Profile section of Localizable.strings")
            
        platformsTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenPlatformsSection", comment: "This is the translation for 'ACscreenPlatformsSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //platformsTitleLabel.accessibilityValue = NSLocalizedString("Platforms", comment: "This is the translation for 'Platforms' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        languagesTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenLanguagesSection", comment: "This is the translation for 'ACscreenLanguagesSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //languagesTitleLabel.accessibilityValue = NSLocalizedString("Languages", comment: "This is the translation for 'Languages' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        gamesTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenGamesSection", comment: "This is the translation for 'ACscreenRatingSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //gamesTitleLabel.accessibilityValue = NSLocalizedString("UserGames", comment: "This is the translation for 'ACscreenGamesSection' at the UserProfile (Profile Tab) section of Localizable.strings")
        
        //Dynamic Types
        let scaledUserProfileNameFont = AccessibilityManager
            .forCustomFont(forTextStyle: .headline, forFontSize: 22, forFontWeight: .bold)
        let scaledUserGamertagFont = AccessibilityManager
            .forCustomFont(forTextStyle: .callout, forFontSize: 9, forFontWeight: .light)
        let scaledProfileBioFont = AccessibilityManager
            .forCustomFont(forTextStyle: .body, forFontSize: 13, forFontWeight: .light)
        let scaledSectionTitle1Font = AccessibilityManager
            .forCustomFont(forTextStyle: .title1, forFontSize: 24, forFontWeight: .bold)
        
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
            
            destination.delegate = self
            destination.user = self.user
        }
        
        if segue.identifier == "toGameDetail" {
            
            guard let game = sender as? Game else { return }
            
            let navViewController = segue.destination as! UINavigationController
            
            let destination = navViewController.topViewController as! GameDetailViewController
            
            destination.game = game
        }
    }
}

//MARK: - ProfileViewController - Setting User Profile Picture

extension ProfileViewController: UserAvatarViewDelegate {
    func didChooseImage() {
        customPicker.pickImage(self) { [unowned self] image, url in
            DispatchQueue.main.async {
                self.userAvatarView.imageURL = url
                self.userAvatarView.contentImage.image = image
                self.userAvatarView.contentImage.contentMode = .scaleAspectFill
                
                if let unwrappedUser = user {
                    CKRepository.editUserData(id: unwrappedUser.id, name: unwrappedUser.name, nickname: unwrappedUser.nickname, location: unwrappedUser.location, description: unwrappedUser.description, photo: url, selectedPlatforms: unwrappedUser.selectedPlatforms, selectedGames: unwrappedUser.selectedGames, languages: unwrappedUser.languages, completion: { _, _ in })
                }
            }
        }
        
    }
}
//MARK: - UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backgroundImageHeightConstraint.constant = 242 - 48 + (-1 * scrollView.contentOffset.y)
        view.layoutIfNeeded()
    }
}

extension ProfileViewController: RoundedRectangleCollectionViewDelegate {
    
    func didSelectRoundedRectangleModel(model: RoundedRectangleModel) {
        guard let game = model as? Game else { return }
        performSegue(withIdentifier: "toGameDetail", sender: game)
    }
    
}

extension ProfileViewController: EditingProfileViewControllerDelegate {
    func didTapDone() {
        self.viewDidLoad()
        
        platformsView.collectionView.reloadData()
        languagesView.collectionView.reloadData()
        gameCollectionView.collectionView.reloadData()
    }
}
