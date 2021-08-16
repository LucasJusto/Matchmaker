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
        
    }

    @IBAction func actionAcceptRequestButton(_ sender: UIButton) {
        
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
        acceptRequestButton.cornerRadius = 10
        rejectRequestButton.cornerRadius = 10
    }

}
