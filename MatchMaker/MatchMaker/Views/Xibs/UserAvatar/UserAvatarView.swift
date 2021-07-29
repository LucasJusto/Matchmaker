//
//  UserAvatarView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

@IBDesignable class UserAvatarView: UIView, NibLoadable {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var buttonBackground: UIImageView!
    @IBOutlet weak var photoButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImage.layer.masksToBounds = true
        contentImage.layer.cornerRadius = 60
        contentImage.layer.cornerCurve = .circular
        
        buttonBackground.layer.masksToBounds = true
        buttonBackground.layer.cornerRadius = 13
        buttonBackground.layer.cornerCurve = .circular
        
        
        contentImage.accessibilityIgnoresInvertColors = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

}
