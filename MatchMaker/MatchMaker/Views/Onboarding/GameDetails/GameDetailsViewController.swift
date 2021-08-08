//
//  GameDetailsViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 08/08/21.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var gameCoverView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameCoverView.image = image
        
    }
    
}

