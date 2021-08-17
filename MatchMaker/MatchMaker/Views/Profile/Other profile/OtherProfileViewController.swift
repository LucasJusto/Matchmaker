//
//  OtherProfileViewController.swift
//  MatchMaker
//
//  Created by Marcelo Diefenbach on 10/08/21.
//

import UIKit

class OtherProfileViewController: UIViewController {
    
    enum isFriend: CustomStringConvertible {
        case friend, request, nonFriend, requestReceived
        
        var description: String {
            switch self {
            case .friend:
                return NSLocalizedString("RemoveFriendButtonLabel", comment: "")
            case .request:
                return NSLocalizedString("CancelRequestButtonLabel", comment: "")
            case .nonFriend:
                return NSLocalizedString("RequestFriendButtonLabel", comment: "")
            case .requestReceived:
                return ""
            }
        }
    }

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
    
    @IBOutlet weak var aceptOrRejectStack: UIStackView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBAction func rejectButtonAction(_ sender: Any) {
        rejeitaAmigo()
    }
    @IBOutlet weak var aceptButton: UIButton!
    @IBAction func aceptButtonAction(_ sender: Any) {
        aceitaAmigo()
    }
    
    @IBOutlet weak var requestFriendButton: UIButton!
    @IBAction func requestFriendButton(_ sender: Any) {
        if friendRequestOrNonFriendControl == isFriend.friend {
            removeFriend()

        } else if friendRequestOrNonFriendControl == isFriend.request {
            cancelFriendRequest()
            
        } else if friendRequestOrNonFriendControl == isFriend.nonFriend {
            addFriend()
        }
    }
    
    @IBAction func rateBehaviourButton(_ sender: Any) {
        //MARK: - open rate screen to rate
    }
    
    @IBAction func rateSkillButton(_ sender: Any) {
        //MARK: - open rate screen to rate
    }
    
    var user: User?
    
    //MARK: - Status of friend
    var friendRequestOrNonFriendControl: isFriend? = isFriend.requestReceived
    
    var marinaGames: [Game] = Games.buildGameArray()
    
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
        aceptButton.layer.cornerRadius = 10
        
        if friendRequestOrNonFriendControl == isFriend.friend {
            aceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
            requestFriendButton.setTitle(isFriend.friend.description, for: .normal)

        } else if friendRequestOrNonFriendControl == isFriend.request {
            aceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
            requestFriendButton.setTitle(isFriend.request.description, for: .normal)
            
        } else if friendRequestOrNonFriendControl == isFriend.nonFriend {
            aceptOrRejectStack.isHidden = true
            requestFriendButton.isHidden = false
            requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
            requestFriendButton.setTitle(isFriend.nonFriend.description, for: .normal)
            
        } else if friendRequestOrNonFriendControl == isFriend.requestReceived {
            aceptOrRejectStack.isHidden = false
            requestFriendButton.isHidden = true
            aceptButton.setTitle(NSLocalizedString("AcceptRequestButton", comment: ""), for: .normal)
            rejectButton.setTitle(NSLocalizedString("RejectRequestButton", comment: ""), for: .normal)
        }
    }
    
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
        
        //MARK: - Implement user informations here (The data that are already here are mocked
        
        //user = User(id: "teste", name: "Marina de Pazzi", nickname: "Prolene", photoURL: nil, location: Locations.brazil, description: "fala fellas, voce que curte um cszinho, bora fazer um projetinho na mansao arromba", behaviourRate: 5.0, skillRate: 5.0, languages: [Languages.english, Languages.portuguese, Languages.russian, Languages.german], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: [marinaGames[1], marinaGames[2]])
        
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
    
    func aceitaAmigo() {
        friendRequestOrNonFriendControl = isFriend.friend
        aceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        aceptButton.setTitle(NSLocalizedString("AcceptRequestButton", comment: ""), for: .normal)
        rejectButton.setTitle(NSLocalizedString("RejectRequestButton", comment: ""), for: .normal)
        //MARK: - Do BackEnd to acept friend
    }

    func rejeitaAmigo() {
        friendRequestOrNonFriendControl = isFriend.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(isFriend.nonFriend.description, for: .normal)
        aceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to reject friend
    }
    
    func addFriend() {
        friendRequestOrNonFriendControl = isFriend.request
        requestFriendButton.layer.backgroundColor = UIColor(named: "LightGray")?.cgColor
        requestFriendButton.setTitle(isFriend.request.description, for: .normal)
        aceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to add to friends
    }
    
    func cancelFriendRequest() {
        friendRequestOrNonFriendControl = isFriend.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(isFriend.nonFriend.description, for: .normal)
        aceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to cancel request
    }
    
    func removeFriend() {
        friendRequestOrNonFriendControl = isFriend.nonFriend
        requestFriendButton.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
        requestFriendButton.setTitle(isFriend.nonFriend.description, for: .normal)
        aceptOrRejectStack.isHidden = true
        requestFriendButton.isHidden = false
        //MARK: - Do BackEnd to remove friend
    }
}
