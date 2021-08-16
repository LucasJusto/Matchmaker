//
//  GameDetailViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 25/07/21.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    // Game mock
    var game: Game = Games.games[0]
    
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
    
    // Xib
    @IBOutlet weak var OtherGamesXib: RoundedRectangleCollectionView!
    
    @IBOutlet weak var titleGameDetailScreen: UINavigationItem!
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var playstationStack: UIStackView!
    @IBOutlet weak var xboxStack: UIStackView!
    @IBOutlet weak var pcStack: UIStackView!
    @IBOutlet weak var mobileStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleGameDetailScreen.title = NSLocalizedString("TitleGameDetailScreen", comment: "Screen title")
        
        // Xib setup
        OtherGamesXib.roundedRectangleImageModels = Games.games
        OtherGamesXib.delegate = self
        
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
        
        playstationStack.isHidden = true
        xboxStack.isHidden = true
        pcStack.isHidden = true
        mobileStack.isHidden = true
        
        //Platforms setup
        for platform in game.platforms {
            switch(platform) {
                case .PC:
                    pcStack.isHidden = false
                case .PlayStation:
                    playstationStack.isHidden = false
                case .Xbox:
                    xboxStack.isHidden = false
                case .Mobile:
                    mobileStack.isHidden = false
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGame" {

            guard let game = sender as? Game else { return }
            
            let destination = segue.destination as? GameDetailViewController

            destination?.game = game
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

extension GameDetailViewController: RoundedRectangleCollectionViewDelegate {
    
    func didSelectRoundedRectangleModel(model: RoundedRectangleModel) {
        
        guard let game = model as? Game else { return }
        print(game.name)
        performSegue(withIdentifier: "toGame", sender: game)
    }
}
