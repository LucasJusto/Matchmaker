//
//  DiscoverShowMoreCollectionViewCell.swift
//  MatchMaker
//
//  Created by João Brentano on 04/08/21.
//

import UIKit

class SocialCollectionViewShowMoreCell: UICollectionViewCell {
    
    var delegate: SocialTableViewFriendCellDelegate?
    var userId: String?
    
    // Outlets
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    // Actions
    @IBAction func actionShowMoreButton(_ sender: Any) {
        delegate?.didPressShowProfileCollection(self)
    }
    
    func setup(userId: String) {
        showMoreView.cornerRadius = 10
        showMoreButton.setTitle(NSLocalizedString("SocialShowMoreButton", comment: "Show more button in discover screen"), for: .normal)
        showMoreButton.contentHorizontalAlignment = .center
        self.userId = userId
        // TO DO
    }
    
}
