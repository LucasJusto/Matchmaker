//
//  HomeMidTableViewCell.swift
//  MatchMaker_uikit
//
//  Created by Marcelo Diefenbach on 29/07/21.
//

import UIKit

class HomeMidTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gamesCollectionView: RoundedRectangleCollectionView!
    
    var games: [Game] = Games.buildGameArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gamesCollectionView.roundedRectangleImageModels = games

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
