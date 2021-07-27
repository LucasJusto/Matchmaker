//
//  ViewController.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 20/07/21.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let games = Games.buildGameArray()
        CKRepository.setOnboardingInfo(name: "Lucas Justo", nickname: "lolzinho", photo: nil, photoURL: nil,country: "Brasil", description: "af", languages: ["tanto faz é teste"], selectedPlatforms: [Platform.PC], selectedGames: [games[1], games[2]])
        
        label.setLabelText(for: "titleLabel", comment: "Title label example")
    }
}

extension UILabel {
    
    func setLabelText(for key: String, comment: String) {
        self.text = NSLocalizedString(key, comment: comment)
    }
    
}
