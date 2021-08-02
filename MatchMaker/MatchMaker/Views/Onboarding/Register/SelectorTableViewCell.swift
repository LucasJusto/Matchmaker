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
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String) {
        titleLabel.text = title
    }
}
