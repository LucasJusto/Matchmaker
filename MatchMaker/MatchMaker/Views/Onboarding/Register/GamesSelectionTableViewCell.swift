//
//  GamesSelectionTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 29/07/21.
//

import UIKit

class GamesSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
