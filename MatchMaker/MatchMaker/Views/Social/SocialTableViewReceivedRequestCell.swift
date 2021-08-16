//
//  SocialTableViewReceivedRequestCell.swift
//  MatchMaker
//
//  Created by João Brentano on 15/08/21.
//

import UIKit

protocol SocialTableViewReceivedRequestCellDelegate: AnyObject {
    func reloadTableView(_ sender: Any)
}

class SocialTableViewReceivedRequestCell: UITableViewCell {

    var userId: String?
    var delegate: SocialTableViewReceivedRequestCellDelegate?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var rejectRequestButton: UIButton!
    @IBOutlet weak var acceptRequestButton: UIButton!
    
    @IBAction func actionRejectRequestButton(_ sender: UIButton) {
        guard let userId = self.userId else { return }
        CKRepository.getUserId(completion: { ownUserId in
            guard let ownUserId = ownUserId else { return }
            CKRepository.friendshipInviteAnswer(inviterUserId: userId, receiverUserId: ownUserId, response: false)
            self.delegate?.reloadTableView(self)
        })
    }

    @IBAction func actionAcceptRequestButton(_ sender: UIButton) {
        guard let userId = self.userId else { return }
        CKRepository.getUserId(completion: { ownUserId in
            guard let ownUserId = ownUserId else { return }
            CKRepository.friendshipInviteAnswer(inviterUserId: userId, receiverUserId: ownUserId, response: true)
            self.delegate?.reloadTableView(self)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(userId: String, photoURL: URL?, name: String, nickname: String) {
        
        // Trying to unwrap, get image data and set it in the UI
        if let url = photoURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.avatar.image = UIImage(data: data)
                    }
                }
            }
        }
        
        self.userId = userId
        self.name.text = name
        self.nickname.text = nickname
        acceptRequestButton.cornerRadius = 5
        acceptRequestButton.setTitle(NSLocalizedString("SocialReceivedRequestAcceptInvite", comment: "Button for accepting a friend request in Social tab"), for: .normal)
        rejectRequestButton.cornerRadius = 5
        rejectRequestButton.setTitle(NSLocalizedString("SocialReceivedRequestDeclineInvite", comment: "Button for declining a friend request in Social tab"), for: .normal)
    }

}
