//
//  ViewController.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 20/07/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = games[0].image
        // Do any additional setup after loading the view.
    }


}

