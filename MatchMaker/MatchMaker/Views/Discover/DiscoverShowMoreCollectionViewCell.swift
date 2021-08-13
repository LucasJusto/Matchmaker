//
//  DiscoverShowMoreCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 04/08/21.
//

import UIKit

class DiscoverShowMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    func setup() {
        showMoreView.cornerRadius = 10
        showMoreButton.setTitle(NSLocalizedString("DiscoverShowMoreButton", comment: "Show more button in discover screen"), for: .normal)
        showMoreButton.contentHorizontalAlignment = .center
        // TO DO
    }
    
}
