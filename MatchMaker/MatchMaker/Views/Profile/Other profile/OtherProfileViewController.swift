//
//  OtherProfileViewController.swift
//  MatchMaker
//
//  Created by Marcelo Diefenbach on 10/08/21.
//

import UIKit

protocol OtherProfileViewDelegate: AnyObject {
    func didChangeSocial()
}

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
    
 
    @IBAction func didTapUpperDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
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
            skillRateButton.isHidden = false
            behavioursRateButton.isHidden = false
        } else {
            skillRateButton.isHidden = true
            behavioursRateButton.isHidden = true
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
        
        skillRateButton.layer.cornerRadius = 8
        behavioursRateButton.layer.cornerRadius = 8
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
