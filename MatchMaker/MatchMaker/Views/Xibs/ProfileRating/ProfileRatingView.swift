//
//  ProfileRatingView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 26/07/21.
//

import UIKit

@IBDesignable class ProfileRatingView: UIView, NibLoadable {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryOfRatingLabel: UILabel!
    @IBOutlet weak var amountOfReviewsLabel: UILabel!
    
    override func awakeFromNib() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.cornerCurve = .continuous
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(named: "Primary")?.cgColor

        contentView.accessibilityIgnoresInvertColors = true
        
        NotificationCenter.default.addObserver(forName: UIAccessibility.invertColorsStatusDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            if UIAccessibility.isInvertColorsEnabled {
                self?.ratingLabel.textColor = .black
                self?.categoryOfRatingLabel.textColor = .black
                self?.amountOfReviewsLabel.textColor = .black
            }
            else {
                self?.ratingLabel.textColor = .white
                self?.categoryOfRatingLabel.textColor = .white
                self?.amountOfReviewsLabel.textColor = .white
            }
        }
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
