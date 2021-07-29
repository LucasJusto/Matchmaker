//
//  ProfileRatingView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 26/07/21.
//

import UIKit

@IBDesignable class ProfileRatingView: UIView, NibLoadable {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryOfRatingLabel: UILabel!
    @IBOutlet weak var amountOfReviewsLabel: UILabel!
    
    override func awakeFromNib() {
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.cornerCurve = .continuous
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor(named: "Primary")?.cgColor

        backgroundView.accessibilityIgnoresInvertColors = true
        
        setDynamicTypes()
        
    }
    
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
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
//    func commonInit() {
//        let nib = UINib(nibName: "ProfileRatingView", bundle: .main)
//        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
//
//        addSubview(contentView)
//
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentView.translatesAutoresizingMaskIntoConstraints = true
//
//        self.contentView = contentView
//    }
}
