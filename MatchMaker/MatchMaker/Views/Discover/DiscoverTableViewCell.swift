//
//  DiscoverTableViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 30/07/21.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NickLabel: UILabel!
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var AddToFriendsButton: UIButton!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var userGames: [Game] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        // Initialization code
        
        AddToFriendsButton.setTitle(NSLocalizedString("DiscoverScreenAddToFriendsButton", comment: "Add to friends button text in the Discover Screen."), for: .normal)
        AddToFriendsButton.cornerRadius = 10
        ProfileImage.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(url: URL?, nameText: String, nickText: String, userGames: [Game]) {
        
        // Trying to unwrap, get image data and set it in the UI
        if let url = url {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.ProfileImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        self.userGames = userGames
        NameLabel.text = nameText
        NickLabel.text = nickText
    }

}

extension DiscoverTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
