//
//  userImageTableViewCell.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 11/08/21.
//

import UIKit

class userImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userAvatarView: UserAvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
