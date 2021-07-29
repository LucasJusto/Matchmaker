//
//  ProfileViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 26/07/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundCoverImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundCoverImage.accessibilityIgnoresInvertColors = true
    }

}
