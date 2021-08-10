//
//  UserAvatarView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

protocol UserAvatarViewDelegate: AnyObject {
    func didChooseImage()
}

//MARK: - UserAvatarView Class

class UserAvatarView: UIView, NibLoadable {
    
    //MARK: UserAvatarView - Variables and Outlets Setup

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var buttonBackground: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
        
    weak var delegate: UserAvatarViewDelegate?
    
    var imageURL: URL?
    
    //var didChooseImage: (() -> Void)?
    
    //MARK: UserAvatarView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImage.layer.masksToBounds = true
        contentImage.layer.cornerRadius = 60
        contentImage.layer.cornerCurve = .circular
        
        buttonBackground.layer.masksToBounds = true
        buttonBackground.layer.cornerRadius = 13
        buttonBackground.layer.cornerCurve = .circular
        
        contentImage.image = UIImage(named: "photoDefault")
        contentImage.accessibilityIgnoresInvertColors = true
    }
    
    //MARK: UserAvatarView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: UserAvatarView - Capturing user photo
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didChooseImage()
        //didChooseImage?()
    }
}
