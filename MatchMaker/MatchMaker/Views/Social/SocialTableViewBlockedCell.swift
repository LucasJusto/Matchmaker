//
//  SocialBlockedTableViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 16/08/21.
//

import UIKit

protocol SocialTableViewBlockedCellDelegate: AnyObject {
    func updateAndReloadBlocked(_ sender: SocialTableViewBlockedCell)
}

class SocialTableViewBlockedCell: UITableViewCell {

    var userId: String?
    var delegate: SocialTableViewBlockedCellDelegate?
    
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    // Actions
    @IBAction func actionUnblockButton(_ sender: UIButton) {
        CKRepository.getUserId(completion: { ownUserId in
            guard let unwrappedUserId = ownUserId else { return }
            self.delegate?.updateAndReloadBlocked(self)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(userId: String, photoURL: URL?, name: String, nickname: String) {
        
        // Trying to unwrap, get image data and set it in the UI
        if let url = photoURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        self.userId = userId
        self.username.text = name
        self.nickname.text = nickname
        unblockButton.cornerRadius = 5
        unblockButton.setTitle(NSLocalizedString("SocialUnblockButton", comment: "Button for unblockina user in the Social tab"), for: .normal)
    }

}
