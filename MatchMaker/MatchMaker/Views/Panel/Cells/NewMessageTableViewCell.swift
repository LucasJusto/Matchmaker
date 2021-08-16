//
//  NewMessageTableViewCell.swift
//  MatchMaker_uikit
//
//  Created by Marcelo Diefenbach on 01/08/21.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var backgroundOutlet: UIView!
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundOutlet.layer.cornerRadius = 8
        squareImage.layer.cornerRadius = 8
        chatButton.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
