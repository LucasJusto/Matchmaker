//
//  HomeTopTableViewCell.swift
//  MatchMaker_uikit
//
//  Created by Marcelo Diefenbach on 29/07/21.
//

import UIKit

class HomeTopTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var filterCoverImage: UIImageView!
    @IBOutlet weak var highlightButtonAboveImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        coverImage.layer.cornerRadius = 10
        filterCoverImage.layer.cornerRadius = 10
        highlightButtonAboveImage.layer.cornerRadius = 10
        
        highlightButtonAboveImage.setTitle(NSLocalizedString("TitleButtonHiglighAboveImage", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
