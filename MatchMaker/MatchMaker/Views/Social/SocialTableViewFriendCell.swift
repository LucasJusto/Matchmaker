//
//  DiscoverTableViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 30/07/21.
//

import UIKit

protocol SocialTableViewFriendCellDelegate: AnyObject {
    func didPressShowProfile(_ sender: SocialTableViewFriendCell)
    func didPressShowProfileCollection(_ sender: SocialCollectionViewShowMoreCell)
}

class SocialTableViewFriendCell: UITableViewCell {

    var userId: String?
    var userGames: [Game] = []
    var delegate: SocialTableViewFriendCellDelegate?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func actionProfileButton(_ sender: UIButton) {
        delegate?.didPressShowProfile(self)
        profileButton.isEnabled = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        profileImage.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(userId: String, url: URL?, nameText: String, nickText: String, userGames: [Game]) {
        profileButton.isEnabled = true
        self.profileImage.image = UIImage(named: "profile_default")
        
        // Trying to unwrap, get image data and set it in the UI
        if let url = url {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data)
                    }
                }
            }
        }
        self.userId = userId
        self.userGames = userGames
        nameLabel.text = nameText
        nickLabel.text = nickText
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension SocialTableViewFriendCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 71, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userGames.count >= 4 {
            return 4
        }
        return userGames.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 3 && userGames.count > 4{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialShowMoreCollectionViewCell", for: indexPath) as? SocialCollectionViewShowMoreCell
            else {
                    return UICollectionViewCell()
            }
            
            guard let userId = self.userId else { return UICollectionViewCell() }
            
            cell.setup(userId: userId)
            cell.delegate = delegate
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialCollectionViewCell", for: indexPath) as? SocialCollectionViewCell
        else {
                return UICollectionViewCell()
        }
        
        let game: Game = userGames[indexPath.row]
        
        var playstation: Bool = false
        var xbox: Bool = false
        var pc: Bool = false
        var mobile: Bool = false
        
        for platform in game.selectedPlatforms {
            switch platform {
            case Platform.PlayStation:
                playstation = true
            case Platform.Xbox:
                xbox = true
            case Platform.PC:
                pc = true
            case Platform.Mobile:
                mobile = true
            }
        }
        
        cell.setup(GameImage: game.image, GameTitle: game.name, isPlaystation: playstation, isXbox: xbox, isPC: pc, isMobile: mobile)
        
        return cell
    }
    
}
