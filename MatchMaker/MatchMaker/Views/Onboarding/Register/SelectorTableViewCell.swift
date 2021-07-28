//
//  SelectorTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 27/07/21.
//

import UIKit

protocol SelectorTableViewCellDelegate: AnyObject {
    func didTapTag(button: UIButton, sender: UITableViewCell)
}

class SelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SelectorTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String) {
        titleLabel.text = title
    }
    
    @objc func selectTag(sender: UIButton) {
        
        delegate?.didTapTag(button: sender, sender: self)

    }

}
