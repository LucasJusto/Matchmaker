//
//  ProfileRatingView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 26/07/21.
//

import UIKit

//MARK: - ProfileRatingView Class

class ProfileRatingView: UIView, NibLoadable {
    
    //MARK: ProfileRatingView - Variables and Outlets Setup
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryOfRatingLabel: UILabel!
    @IBOutlet weak var amountOfReviewsLabel: UILabel!
    
    //MARK: ProfileRatingView - View Setup
    
    override func awakeFromNib() {
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.cornerCurve = .continuous
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor(named: "Primary")?.cgColor

        backgroundView.accessibilityIgnoresInvertColors = true
        
        setDynamicTypes()
        
    }
    
    //MARK: ProfileRatingView - Nib Setup
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    //MARK: ProfileRatingView - Accessibility Features: Dynamic Types
    
    func setDynamicTypes(){
        let bodyMetrics = UIFontMetrics(forTextStyle: .body)
        
        let categoryLabelFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        let amountOfReviewsFont = UIFont.systemFont(ofSize: 8, weight: .regular)
        
        let scaledCategoryLabelFont = bodyMetrics.scaledFont(for: categoryLabelFont)
        let scaledAmountOfReviewsFont = bodyMetrics.scaledFont(for: amountOfReviewsFont)
        
        categoryOfRatingLabel.font = scaledCategoryLabelFont
        categoryOfRatingLabel.adjustsFontForContentSizeCategory = true
        
        amountOfReviewsLabel.font = scaledAmountOfReviewsFont
        amountOfReviewsLabel.adjustsFontForContentSizeCategory = true
    }
}
