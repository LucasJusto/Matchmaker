//
//  DiscoverShowMoreCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 04/08/21.
//

import UIKit

class DiscoverShowMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ShowMoreView: UIView!
    @IBOutlet weak var ShowMoreLabel: UILabel!
    
    func setup() {
        ShowMoreView.cornerRadius = 10
        ShowMoreLabel.text = NSLocalizedString("ShowMoreButton", comment: "Show more button in discover screen")
        // TO DO
    }
    
}
