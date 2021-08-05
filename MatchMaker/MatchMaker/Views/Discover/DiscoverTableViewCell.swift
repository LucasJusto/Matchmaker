//
//  DiscoverTableViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 30/07/21.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addToFriendsButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userGames: [Game] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialization code
        
        addToFriendsButton.cornerRadius = 10
        profileImage.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(profileImage: UIImage, nameText: String, nickText: String, userGames: [Game]) {
        self.profileImage.image = profileImage
        self.userGames = userGames
        nameLabel.text = nameText
        nickLabel.text = nickText
    }

}

extension DiscoverTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 71, height: 110)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionShowMoreButton", for: indexPath) as? DiscoverShowMoreCollectionViewCell
            else {
                    return UICollectionViewCell()
            }
            
            cell.setup()
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionCell", for: indexPath) as? DiscoverCollectionViewCell
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
