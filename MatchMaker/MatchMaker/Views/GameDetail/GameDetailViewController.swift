//
//  GameDetailViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 25/07/21.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    // Game mock
    let game = (Games.buildGameArray()[1])
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FindPlayersButton.cornerRadius = 10
        AddToMyGamesButton.cornerRadius = 10
        
        // Game info
        GameImage.image = game.image
        GameTitle.text = game.name
        GameDescription.text = game.description
        for platform in game.platforms {
            switch(platform) {
                case .PC:
                    PCImage.image = UIImage(named: "PC_selected")
                case .PlayStation:
                    PlaystationImage.image = UIImage(named: "Play_selected")
                case .Xbox:
                    XboxImage.image = UIImage(named: "Xbox_selected")
                case .Mobile:
                    MobileImage.image = UIImage(named: "Mobile_selected")
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
