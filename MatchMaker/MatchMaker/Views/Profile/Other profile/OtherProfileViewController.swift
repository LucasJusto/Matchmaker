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
    @IBOutlet weak var behavioursRateButton: UIView!
    @IBOutlet weak var skillRateButton: UIButton!
    
    @IBOutlet weak var behaviourRateLabel: UILabel!
    @IBOutlet weak var amountOfReviewsBehavioursLabel: UILabel!
    @IBOutlet weak var skillRateLabel: UILabel!
    @IBOutlet weak var amaountOfReviewsSKillLaber: UILabel!
    
    @IBOutlet weak var acceptOrRejectStack: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var requestFriendButton: UIButton!
    
    //MARK: OtherProfileViewController Outlet functions
    
    @IBAction func rejectButtonAction(_ sender: Any) {
        denyFriendshipRequest()
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        acceptFriendshipRequest()
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
        //MARK: - open rate screen to rate
    }
    
    @IBAction func rateSkillButton(_ sender: Any) {
        //MARK: - open rate screen to rate
    }
    
    //MARK: OtherProfileViewController Variables setup
    
    var user: User?
    var social: Social?
    var friendshipStatus: FriendshipStatus?
    var marinaGames: [Game] = Games.buildGameArray()
    
    //MARK: OtherProfileViewController Class setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserProfile()
        
        setCornerContainerRate()
        
        titleViewLabel.title = NSLocalizedString("TitleViewRate", comment: "")
        
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = 60
        userProfileImage.layer.cornerCurve = .circular
        
        requestFriendButton.layer.cornerRadius = 10
        rejectButton.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 10
                
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
        
        skillRateButton.layer.cornerRadius = 8
        behavioursRateButton.layer.cornerRadius = 8
    }
    
    private func setupUserProfile() {
        
        guard let unwrappedUser = user else { return }
        
        behaviourRateLabel.text = String(unwrappedUser.behaviourRate)
        amountOfReviewsBehavioursLabel.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        
        skillRateLabel.text = String(unwrappedUser.skillRate)
        amaountOfReviewsSKillLaber.text = "0 " + NSLocalizedString("UserReviews", comment: "This is the key for 'reviews' translation")
        
        userProfileNameLabel.text = unwrappedUser.name
        userProfileGamertagLabel.text = "@" + unwrappedUser.nickname
        userProfileBioLabel.text = unwrappedUser.description
        userProfileLocationLabel.text = NSLocalizedString("PlayingFrom", comment: "") + " colocar a localização aqui "
        
        //userProfileImage.image = colocar imagem do usuário
        
        platformsView.smallLabeledImageModels = unwrappedUser.selectedPlatforms
        languagesView.titleModels = unwrappedUser.languages
        gameCollectionView.roundedRectangleImageModels = unwrappedUser.selectedGames
    }
}

extension OtherProfileViewController {
    //funções dos botões
    
    /**
     This function is responsible for accepting a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    //TA FUNCIONANDO ESSE AQUI
    func acceptFriendshipRequest() {
        friendshipStatus = FriendshipStatus.friendsAlready
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.friendsAlready.description, for: .normal)
        //MARK: - Do BackEnd to acept friend
        
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
    //TA FUNCIONANDO ESSE AQUI
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
    //TA FUNCIONANDO ESSE AQUI
    func sendFriendshipRequest() {
        friendshipStatus = FriendshipStatus.requestedFriendship
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        requestFriendButton.setTitle(FriendshipStatus.requestedFriendship.description, for: .normal)
        acceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to add to friends
        
        guard let user = user else { return }
        CKRepository.getUserId { id in
            guard let id = id else { return }
            CKRepository.sendFriendshipInvite(inviterUserId: id, receiverUserId: user.id)
        }
    }
    
    /**
     This function is responsible for canceling a friend request to another user.
     
     - Parameters: Void
     - Returns: Void
     */
    //TA FUNCIONANDO ESSE AQUI
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
