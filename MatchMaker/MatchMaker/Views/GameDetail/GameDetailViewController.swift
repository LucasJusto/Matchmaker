//
//  GameDetailViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 25/07/21.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    // Game mock
    let game = Games.games[0]
    
    // Game info
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var GameTitle: UILabel!
    @IBOutlet weak var GameDescription: UILabel!
    
    // Platform images
    @IBOutlet weak var PlaystationImage: UIImageView!
    @IBOutlet weak var XboxImage: UIImageView!
    @IBOutlet weak var PCImage: UIImageView!
    @IBOutlet weak var MobileImage: UIImageView!
    
    // Butttons
    @IBOutlet weak var FindPlayersButton: UIButton!
    @IBOutlet weak var AddToMyGamesButton: UIButton!
    
    // Labels
    @IBOutlet weak var PlatformsLabel: UILabel!
    @IBOutlet weak var OtherGamesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Label setup
        PlatformsLabel.text = NSLocalizedString("PlatformsLabel", comment: "Platforms label")
        OtherGamesLabel.text = NSLocalizedString("OtherGamesLabel", comment: "Other games label")
        
        // Button setup
        FindPlayersButton.cornerRadius = 10
        AddToMyGamesButton.cornerRadius = 10
        FindPlayersButton.setTitle(NSLocalizedString("FindPlayersButton", comment: "Button on GameDetailView for searching players to play with"), for: UIControl.State.init())
        AddToMyGamesButton.setTitle(NSLocalizedString("AddToMyGamesButton", comment: "Button on GameDetailView to add a game to the user's games"), for: UIControl.State.init())
        // Game info
        GameImage.image = game.image
        GameTitle.text = game.name
        GameDescription.text = game.description
        for platform in game.platforms {
            switch(platform) {
                case .PC:
                    PCImage.image = UIImage(named: platform.imageSelected)
                case .PlayStation:
                    PlaystationImage.image = UIImage(named: platform.imageSelected)
                case .Xbox:
                    XboxImage.image = UIImage(named: platform.imageSelected)
                case .Mobile:
                    MobileImage.image = UIImage(named: platform.imageSelected)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
