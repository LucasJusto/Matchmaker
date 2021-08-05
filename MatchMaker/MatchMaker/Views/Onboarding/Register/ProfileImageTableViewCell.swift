//
//  ProfileImageTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBAction func pressedCameraButton(_ sender: Any) {
        print("pressionou camera btn")
        cameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        profileImageView.image = UIImage(named: "game")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(profileImage: UIImage?) {
        
        if let profileImage = profileImage {
            profileImageView.image = profileImage
            return;
        }
        
        profileImageView.image = UIImage(named: "profile_default")
    }

}
