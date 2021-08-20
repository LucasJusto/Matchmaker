//
//  OtherProfileViewController.swift
//  MatchMaker
//
//  Created by Marcelo Diefenbach on 10/08/21.
//

import UIKit

//MARK: - OtherProfileViewController Class

class OtherProfileViewController: UIViewController {
    
    //MARK: FriendshipStatus Enum
    
    enum FriendshipStatus: CustomStringConvertible {
        case friendsAlready, requestedFriendship, nonFriend, pendingRequest
        
        var description: String {
            switch self {
            case .friendsAlready:
                return NSLocalizedString("RemoveFriendButtonLabel", comment: "")
            case .requestedFriendship:
                return NSLocalizedString("CancelRequestButtonLabel", comment: "")
            case .nonFriend:
                return NSLocalizedString("RequestFriendButtonLabel", comment: "")
            case .pendingRequest:
                return ""
            }
        }
    }
    
    var socialViewController: SocialViewController?
    
    //MARK: OtherProfileViewController Outlets setup

    @IBOutlet weak var titleViewLabel: UINavigationItem!
    
    @IBOutlet weak var platformsView: SmallLabeledImageCollectionView!
    @IBOutlet weak var languagesView: TitleCollectionView!
    @IBOutlet weak var gameCollectionView: RoundedRectangleCollectionView!
    
    @IBOutlet weak var ratingsTitleLabel: UILabel!
    @IBOutlet weak var platformsTitleLabel: UILabel!
    @IBOutlet weak var languagesTitleLabel: UILabel!
    @IBOutlet weak var gamesTitleLabel: UILabel!
    
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var userProfileGamertagLabel: UILabel!
    @IBOutlet weak var userProfileBioLabel: UILabel!
    @IBOutlet weak var userProfileLocationLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var behavioursRateContainer: UIView!
    @IBOutlet weak var skillRateContainer: UIView!
    @IBOutlet weak var skillRateButton: UIView!
    @IBOutlet weak var behaviourRateButton: UIButton!
    
    @IBOutlet weak var behaviourRateLabel: UILabel!
    @IBOutlet weak var amountOfReviewsBehavioursLabel: UILabel!
    @IBOutlet weak var skillRateLabel: UILabel!
    @IBOutlet weak var amaountOfReviewsSKillLaber: UILabel!
    @IBOutlet weak var behaviourCategory: LocalizableLabel!
    @IBOutlet weak var skillCategory: LocalizableLabel!
    
    @IBOutlet weak var acceptOrRejectStack: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var requestFriendButton: UIButton!
    
    
    @IBOutlet weak var upperDone: UIBarButtonItem!
    
    //MARK: OtherProfileViewController Outlet functions
    
 
    @IBAction func didTapUpperDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func rejectButtonAction(_ sender: Any) {
        denyFriendshipRequest()
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        acceptFriendshipRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socialViewController?.socialTableView.reloadData()
    }
    
    @IBAction func requestFriendButton(_ sender: Any) {
        guard let social = social else { return }
        
        if ((social.isInviter == nil) && (social.isInvite == nil)) {
            sendFriendshipRequest()
        } else if (!(social.isInviter ?? false) && (social.isInvite == .yes)) {
            cancelFriendRequest()
        } else if social.isInvite == IsInvite.no {
            if social.isInviter == true {
                CKRepository.getUserId { userID in
                    guard let userID = userID else { return }
                    self.removeFriend(inviterId: social.id, receiverId: userID)
                }
            }
            else {
                CKRepository.getUserId { userID in
                    guard let userID = userID else { return }
                    self.removeFriend(inviterId: userID, receiverId: social.id)
                }
            }
            
        }
    }
    
    @IBAction func rateBehaviourButton(_ sender: Any) {
        performSegue(withIdentifier: "toRateUser", sender: RateType.behaviour)
    }
    
    @IBAction func rateSkillButton(_ sender: Any) {
        performSegue(withIdentifier: "toRateUser", sender: RateType.skill)
    }
    
    //MARK: OtherProfileViewController Variables setup
    
    var user: User?
    var social: Social?
    var friendshipStatus: FriendshipStatus?
    var userGames: [Game] = []
    var discoverViewController: DiscoverViewController?
    
    //MARK: OtherProfileViewController Class setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserProfile()
        
        setupAccessibiltyFeatures()
        
        setCornerContainerRate()
        
        titleViewLabel.title = NSLocalizedString("TitleViewRate", comment: "")
        
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = 60
        userProfileImage.layer.cornerCurve = .circular
        
        requestFriendButton.layer.cornerRadius = 10
        rejectButton.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 10
        
        let amigo = (social?.isInvite == .no ? true : false) ?? false
        
        if amigo {
            behaviourRateButton.isHidden = false
            skillRateButton.isHidden = false
        } else {
            behaviourRateButton.isHidden = true
            skillRateButton.isHidden = true
        }
                
        guard let social = social else { return }
        
        if ((social.isInviter == nil) && (social.isInvite == nil)) {
            acceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
            requestFriendButton.setTitle(FriendshipStatus.nonFriend.description, for: .normal)
            
        } else if social.isInvite == IsInvite.no {
            acceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
            requestFriendButton.setTitle(FriendshipStatus.friendsAlready.description, for: .normal)

        } else if (!(social.isInviter ?? true) && (social.isInvite == .yes))  {
            acceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
            requestFriendButton.setTitle(FriendshipStatus.requestedFriendship.description, for: .normal)
            
        } else if ((social.isInviter ?? false) && (social.isInvite == .yes)) {
            acceptOrRejectStack.isHidden = false
            requestFriendButton.isHidden = true
            acceptButton.setTitle(NSLocalizedString("AcceptRequestButton", comment: ""), for: .normal)
            rejectButton.setTitle(NSLocalizedString("RejectRequestButton", comment: ""), for: .normal)
        }
    }
    
    //MARK: OtherProfileViewController Class functions
    
    func setCornerContainerRate() {
        behavioursRateContainer.layer.cornerRadius = 10
        behavioursRateContainer.layer.borderWidth = 1
        behavioursRateContainer.layer.borderColor = UIColor(named: "Primary")?.cgColor
        
        skillRateContainer.layer.cornerRadius = 10
        skillRateContainer.layer.borderWidth = 1
        skillRateContainer.layer.borderColor = UIColor(named: "Primary")?.cgColor
        
        behaviourRateButton.layer.cornerRadius = 8
        skillRateButton.layer.cornerRadius = 8
    }
    
    private func setupUserProfile() {
        
        guard let unwrappedUser = user else { return }
        
        if let url = unwrappedUser.photoURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.userProfileImage.image = UIImage(data: data)
                    }
                }
            }
        } else {
            self.userProfileImage.image = UIImage(named: "photoDefault")
        }
        
        behaviourRateLabel.text = String(unwrappedUser.behaviourRate)
        //amountOfReviewsBehavioursLabel.text = "0" + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        
        skillRateLabel.text = String(unwrappedUser.skillRate)
        //amaountOfReviewsSKillLaber.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        
        userProfileNameLabel.text = unwrappedUser.name
        userProfileGamertagLabel.text = "@" + unwrappedUser.nickname
        userProfileBioLabel.text = unwrappedUser.description
        userProfileLocationLabel.text = NSLocalizedString("Playing from ", comment: "") + "\(unwrappedUser.location)"
        
        //userProfileImage.image = colocar imagem do usuário
        
        platformsView.smallLabeledImageModels = unwrappedUser.selectedPlatforms
        languagesView.titleModels = unwrappedUser.languages
        gameCollectionView.roundedRectangleImageModels = unwrappedUser.selectedGames
        
        gameCollectionView.delegate = self
    }
    
    func setupAccessibiltyFeatures(){
        guard let unwrappedUser = user,
              let social = social
        else { return }

        
        //Voice over - User profile
        userProfileNameLabel.accessibilityLabel = NSLocalizedString("ACuserName", comment: "This is the translation for 'ACuserName' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileNameLabel.accessibilityValue = unwrappedUser.name
        
        userProfileGamertagLabel.accessibilityLabel = NSLocalizedString("ACuserGamertag", comment: "This is the translation for 'ACuserGamertag' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileGamertagLabel.accessibilityValue = unwrappedUser.nickname
        
        userProfileBioLabel.accessibilityLabel = NSLocalizedString("ACuserBio", comment: "This is the translation for 'ACuserBio' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileBioLabel.accessibilityValue = unwrappedUser.description
        
        userProfileLocationLabel.accessibilityLabel = NSLocalizedString("ACuserLocation", comment: "This is the translation for 'ACuserLocation' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        userProfileLocationLabel.accessibilityValue = "\(unwrappedUser.location)"
        
        //voice over - screen setup
        //bar button setup
        upperDone.accessibilityLabel = NSLocalizedString("ACupperDoneButton", comment: "This is the translation for 'ACupperDoneButton' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        upperDone.accessibilityHint = NSLocalizedString("ACupperDoneButtonHint", comment: "This is the translation for 'ACupperDoneButtonHint' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        
        //friends button stack
        acceptButton.accessibilityHint = NSLocalizedString("ACacceptFriendRequestHint", comment: "This is the translation for 'ACacceptFriendRequestHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name
        rejectButton.accessibilityHint = NSLocalizedString("ACdenyFriendRequestHint", comment: "This is the translation for 'ACdenyFriendRequestHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name
                
        if ((social.isInviter == nil) && (social.isInvite == nil)) {
            //send friend request
            requestFriendButton.accessibilityHint = NSLocalizedString("ACsendFriendRequestHint", comment: "This is the translation for 'ACsendFriendRequestHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name
            
        } else if social.isInvite == IsInvite.no {
            //remove friend
            requestFriendButton.accessibilityHint = NSLocalizedString("ACdeleteFriendshipHint", comment: "This is the translation for 'ACsendFriendRequestHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name + NSLocalizedString("ACdeleteFriendshipHint2", comment: "This is the translation for 'ACdeleteFriendshipHint2' at the Accessibility - Profile/Other Profile section of Localizable.strings")

        } else if (!(social.isInviter ?? true) && (social.isInvite == .yes))  {
            //cancel request
            requestFriendButton.accessibilityHint = NSLocalizedString("ACcancelFriendRequestHint", comment: "This is the translation for 'ACcancelFriendRequestHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name
        }
        
        //rating view
        //behavior rating grade
        behaviourRateLabel.accessibilityLabel = NSLocalizedString("ACratingsResult", comment: "This is the translation for 'ACratingsResult' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        behaviourRateLabel.accessibilityValue = String(unwrappedUser.behaviourRate)
        
        //skill rating grade
        skillRateLabel.accessibilityLabel = NSLocalizedString("ACratingsResult", comment: "This is the translation for 'ACratingsResult' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        skillRateLabel.accessibilityValue = String(unwrappedUser.skillRate)
        
        //behaviour rating category
        behaviourCategory.accessibilityLabel = NSLocalizedString("ACratingsCategory", comment: "This is the translation for 'ACratingsCategory' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        behaviourCategory.accessibilityValue = NSLocalizedString("UserBehaviour", comment: "This is the translation for 'UserBehaviour' at the UserProfile section of Localizable.strings")
        
        //skill rating category
        skillCategory.accessibilityLabel = NSLocalizedString("ACratingsCategory", comment: "This is the translation for 'ACratingsCategory' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        skillCategory.accessibilityValue = NSLocalizedString("UserSkills", comment: "This is the translation for 'UserSkills' at the UserProfile section of Localizable.strings")
        
        //rating buttons
        behaviourRateButton.accessibilityHint = NSLocalizedString("ACrateFriendBehaviourHint", comment: "This is the translation for 'ACrateFriendBehaviourHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name + NSLocalizedString("ACrateFriendBehaviourHint2", comment: "This is the translation for 'ACrateFriendBehaviourHint2' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        skillRateButton.accessibilityHint = NSLocalizedString("ACrateFriendSkillHint", comment: "This is the translation for 'ACrateFriendSkillHint' at the Accessibility - Profile/Other Profile section of Localizable.strings") + unwrappedUser.name + NSLocalizedString("ACrateFriendSkillHint2", comment: "This is the translation for 'ACrateFriendSkillHint2' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        
        
        //screen titles
        ratingsTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenRatingSection", comment: "This is the translation for 'ACscreenRatingSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //ratingsTitleLabel.accessibilityValue = NSLocalizedString("Ratings", comment: "This is the translation for 'Ratings' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        platformsTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenPlatformsSection", comment: "This is the translation for 'ACscreenPlatformsSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //platformsTitleLabel.accessibilityValue = NSLocalizedString("Platforms", comment: "This is the translation for 'Platforms' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        languagesTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenLanguagesSection", comment: "This is the translation for 'ACscreenLanguagesSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //languagesTitleLabel.accessibilityValue = NSLocalizedString("Languages", comment: "This is the translation for 'Languages' at the Friend Profile (OtherPrifile) section of Localizable.strings")
        
        gamesTitleLabel.accessibilityLabel = NSLocalizedString("ACscreenGamesSection", comment: "This is the translation for 'ACscreenRatingSection' at the Accessibility - Profile/Other Profile section of Localizable.strings")
        //gamesTitleLabel.accessibilityValue = NSLocalizedString("UserGames", comment: "This is the translation for 'ACscreenGamesSection' at the UserProfile (Profile Tab) section of Localizable.strings")
        
        //Color Invert
        userProfileImage.accessibilityIgnoresInvertColors = true
        
        //Setting up Dynamic types
        let scaledHeadlineFont = AccessibilityManager.forHeadline()
        let scaledTitleFont = AccessibilityManager.forTitle1()
        let scaledBodyFont = AccessibilityManager.forBody()
        let scaledCalloutFont = AccessibilityManager.forCallout()
        
        userProfileNameLabel.font = scaledHeadlineFont
        userProfileNameLabel.adjustsFontForContentSizeCategory = true
        
        userProfileGamertagLabel.font = scaledCalloutFont
        userProfileGamertagLabel.adjustsFontForContentSizeCategory = true
        
        userProfileBioLabel.font = scaledBodyFont
        userProfileBioLabel.adjustsFontForContentSizeCategory = true
        
        userProfileLocationLabel.font = scaledCalloutFont
        userProfileLocationLabel.adjustsFontForContentSizeCategory = true
        
        ratingsTitleLabel.font = scaledTitleFont
        ratingsTitleLabel.adjustsFontForContentSizeCategory = true
        
        platformsTitleLabel.font = scaledTitleFont
        platformsTitleLabel.adjustsFontForContentSizeCategory = true
        
        languagesTitleLabel.font = scaledTitleFont
        languagesTitleLabel.adjustsFontForContentSizeCategory = true
        
        gamesTitleLabel.font = scaledTitleFont
        gamesTitleLabel.adjustsFontForContentSizeCategory = true
    }
    
    //MARK: OtherProfileViewController Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRateUser" {
            let rootVC = segue.destination as! UINavigationController
            let destination = rootVC.topViewController as! RateViewController
            
            destination.user = user
            destination.social = social
            if let sender = sender as? RateType {
                destination.typeRate = sender == .skill ? .skill : .behaviour
            }
        }
        
        if segue.identifier == "toGameDetail" {
            
            guard let game = sender as? Game else { return }
            
            let navViewController = segue.destination as! UINavigationController
            
            let destination = navViewController.topViewController as! GameDetailViewController
            
            destination.game = game
        }
    }
}

extension OtherProfileViewController {
    //funções dos botões
    
    /**
     This function is responsible for accepting a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    func acceptFriendshipRequest() {
        friendshipStatus = FriendshipStatus.friendsAlready
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.friendsAlready.description, for: .normal)
        //MARK: - Do BackEnd to accept friend
        
        guard let user = user else { return }
        CKRepository.getUserId { id in
            guard let id = id else { return }
            CKRepository.friendshipInviteAnswer(inviterUserId: id, receiverUserId: user.id, response: true)
        }
    }
    
    /**
     This function is responsible for rejecting a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    func denyFriendshipRequest() {
        friendshipStatus = FriendshipStatus.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.nonFriend.description, for: .normal)
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to reject friend
        
        guard let user = user else { return }
        CKRepository.getUserId { id in
            guard let id = id else { return }
            CKRepository.friendshipInviteAnswer(inviterUserId: id, receiverUserId: user.id, response: false)
        }
    }
    
    /**
     This function is responsible for sending a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    func sendFriendshipRequest() {
        friendshipStatus = FriendshipStatus.requestedFriendship
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.requestedFriendship.description, for: .normal)
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        social?.isInvite = .yes
        social?.isInviter = false
        //MARK: - Do BackEnd to add to friends
        
        guard let user = user else { return }
        CKRepository.getUserId { id in
            guard let id = id else { return }
            CKRepository.sendFriendshipInvite(inviterUserId: id, receiverUserId: user.id) { inviteSuccessful in
                if inviteSuccessful {
                    self.social?.isInvite = .yes
                    self.social?.isInviter = true
                    DispatchQueue.main.async {
                        if let unwrappedParent = self.discoverViewController {
                            for i in 0..<unwrappedParent.users.count {
                                if unwrappedParent.users[i].id == self.social?.id {
                                    unwrappedParent.users.remove(at: i)
                                    unwrappedParent.discoverTableView.reloadData()
                                    break
                                }
                            }
                            for i in 0..<unwrappedParent.filteredUsers.count {
                                if unwrappedParent.filteredUsers[i].id == self.social?.id {
                                    unwrappedParent.filteredUsers.remove(at: i)
                                    unwrappedParent.discoverTableView.reloadData()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     This function is responsible for canceling a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    func cancelFriendRequest() {
        friendshipStatus = FriendshipStatus.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.nonFriend.description, for: .normal)
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to cancel request
        
        guard let user = user else { return }
        CKRepository.getUserId { id in
            guard let id = id else { return }
            CKRepository.deleteFriendship(inviterId: id, receiverId: user.id) { }
        }
    }
    
    /**
     This function is responsible for removing a friend from the friends list.
     
     - Parameters: Void
     - Returns: Void
     */
    func removeFriend(inviterId: String, receiverId: String) {
        friendshipStatus = FriendshipStatus.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.nonFriend.description, for: .normal)
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to remove friend
        
        CKRepository.deleteFriendship(inviterId: inviterId, receiverId: receiverId) { }
    }
}

extension OtherProfileViewController: RoundedRectangleCollectionViewDelegate {
    
    func didSelectRoundedRectangleModel(model: RoundedRectangleModel) {
        guard let game = model as? Game else { return }
        performSegue(withIdentifier: "toGameDetail", sender: game)
    }
    
}
