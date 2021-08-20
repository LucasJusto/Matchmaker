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
        
        setupAccessibilityFeatures()
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
    
    func setupAccessibilityFeatures(){
        //Invert Colors
        backgroundView.accessibilityIgnoresInvertColors = true
        
        //Dynamic Types
        let scaled13BodyFont = AccessibilityManager.forCustomFont(forTextStyle: .body, forFontSize: 13, forFontWeight: .regular)
        let scaled8BodyFont = AccessibilityManager.forCustomFont(forTextStyle: .body, forFontSize: 8, forFontWeight: .regular)
        
        categoryOfRatingLabel.font = scaled13BodyFont
        categoryOfRatingLabel.adjustsFontForContentSizeCategory = true
        
        amountOfReviewsLabel.font = scaled8BodyFont
        amountOfReviewsLabel.adjustsFontForContentSizeCategory = true
    }
}
