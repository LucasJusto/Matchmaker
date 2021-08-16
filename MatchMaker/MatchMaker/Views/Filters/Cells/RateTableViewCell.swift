//
//  RateTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 13/08/21.
//

import UIKit

class RateTapGestureRecognizer: UITapGestureRecognizer {
    var starValue: Int?
}

protocol RateTableViewCellDelegate: AnyObject {
    func didTap(currentRate: Int, tag: Int)
}

class RateTableViewCell: UITableViewCell {
    typealias StarStatus = (rate: Int, isSelected: Bool)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var stars: [UIImageView]!
    
    weak var delegate: RateTableViewCellDelegate?
    
    var currentRate = 0 {
        didSet {
            delegate?.didTap(currentRate: currentRate, tag: self.tag)
        }
    }
    
    var starsStatus: [StarStatus] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for star in stars {
            let tapGesture = RateTapGestureRecognizer(target: self, action: #selector(tapSelector(sender:)))
            
            tapGesture.starValue = star.tag
            
            star.addGestureRecognizer(tapGesture)
            
            starsStatus.append(StarStatus(rate: star.tag, isSelected: false))
        }
    }
    
    @objc func tapSelector(sender: RateTapGestureRecognizer) {
        guard let starValue = sender.starValue,
              let starIndex = stars.firstIndex(where: { $0.tag == starValue })
        else { return }
        
        let selectedIcon = UIImage(systemName: "star.fill")
        let unselectedIcon = UIImage(systemName: "star")

        if starValue < currentRate {
            
            if starValue == 1 {
                stars[starIndex].image = unselectedIcon
            }
                            
            for index in (starIndex+1)..<currentRate {
                stars[index].image = unselectedIcon
            }
            
        } else {
            
            for index in 0...starIndex {
                stars[index].image = selectedIcon
            }
        }
        
        currentRate = starValue
    }
}
