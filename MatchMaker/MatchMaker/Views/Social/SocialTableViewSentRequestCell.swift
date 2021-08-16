//
//  SocialTableViewSentRequestCell.swift
//  MatchMaker
//
//  Created by João Brentano on 15/08/21.
//

import UIKit

protocol SocialTableViewSentRequestCellDelegate: AnyObject {
    func reloadTableView(_ sender: Any)
}

class SocialTableViewSentRequestCell: UITableViewCell {
    
    var userId: String?
    var delegate: SocialTableViewSentRequestCellDelegate?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var cancelRequestButton: UIButton!
    
    @IBAction func actionCancelRequestButton(_ sender: Any) {
        guard let userId = userId else { return }
        CKRepository.getUserId(completion: { ownUserId in
            guard let unwrappedOwnUserId = ownUserId else { return }
            CKRepository.deleteFriendship(inviterId: unwrappedOwnUserId, receiverId: userId, completion: {
                self.delegate?.reloadTableView(self)
            })
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
        cancelRequestButton.cornerRadius = 5
        cancelRequestButton.setTitle(NSLocalizedString("SocialViewCancelSentRequest", comment: "Cancel already sent request in Social screen"), for: .normal)
    }

}
