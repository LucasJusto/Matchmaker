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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(profileImage: UIImage, nameText: String, nickText: String) {
        self.profileImage.image = profileImage
        nameLabel.text = nameText
        nickLabel.text = nickText
    }

}
