//
//  DiscoverShowMoreCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 04/08/21.
//

import UIKit

class DiscoverShowMoreCollectionViewCell: UICollectionViewCell {
    
    var delegate: DiscoverTableViewCellDelegate?
    var userId: String?
    
    // Outlets
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    // Actions
    @IBAction func actionShowMoreButton(_ sender: UIButton) {
        delegate?.didPressShowProfileCollection(self)
    }
    
    func setup(userId: String) {
        showMoreView.cornerRadius = 10
        showMoreButton.setTitle(NSLocalizedString("DiscoverShowMoreButton", comment: "Show more button in discover screen"), for: .normal)
        showMoreButton.contentHorizontalAlignment = .center
        self.userId = userId
        // TO DO
    }
    
}
