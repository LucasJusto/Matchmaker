//
//  RequestFriendTableViewCell.swift
//  MatchMaker_uikit
//
//  Created by Marcelo Diefenbach on 29/07/21.
//

import UIKit

class RequestFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var BackgroundOutlet: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var AceptButton: UIButton!
    @IBOutlet weak var RejectButton: UIButton!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var NotificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        BackgroundOutlet.layer.cornerRadius = 10
        ProfileImage.layer.cornerRadius = 8
        AceptButton.layer.cornerRadius = 8
        RejectButton.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
protocol NonHighlightableCell {
    func noSelectionStyle()
}

extension UITableViewCell: NonHighlightableCell {
    func noSelectionStyle() {
        self.selectionStyle = .none
    }
}
