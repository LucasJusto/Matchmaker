//
//  SelectorTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 27/07/21.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var collectionView: UICollectionView!
        
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var requiredLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String) {
        titleLabel.text = title
    }
}
