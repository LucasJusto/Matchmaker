//
//  DiscoverShowMoreCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 04/08/21.
//

import UIKit

class SocialShowMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ShowMoreView: UIView!
    @IBOutlet weak var ShowMoreLabel: UILabel!
    
    func setup() {
        ShowMoreView.cornerRadius = 10
        ShowMoreLabel.text = NSLocalizedString("DiscoverShowMoreButton", comment: "Show more button in discover screen")
        // TO DO
    }
    
}
