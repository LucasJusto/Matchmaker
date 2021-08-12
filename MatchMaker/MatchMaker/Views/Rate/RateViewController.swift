//
//  RateViewController.swift
//  MatchMaker
//
//  Created by Marcelo Diefenbach on 07/08/21.
//

import UIKit

enum RateType: CustomStringConvertible {
    case skill, behaviour
    
    var description: String {
        switch self {
        case .skill:
            return NSLocalizedString("SkillRateLabel", comment: "")
        case .behaviour:
            return NSLocalizedString("BehaviorRateLabel", comment: "")
        }
    }
}

class RateViewController: UIViewController {

    @IBOutlet weak var backgroundStars: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var explainRateLabel: UILabel!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFor: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var typeRateLabel: UILabel!

    @IBOutlet weak var navBarButtonLabel: UIBarButtonItem!
    @IBOutlet weak var titleModalView: UINavigationItem!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // colocar o back pra salvar a nota
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // colocar o back pra salvar a nota
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var Rate: Int = 0
    var typeRate: RateType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        
        backgroundStars.layer.cornerRadius = 10
        backgroundStars.layer.borderWidth = 1
        backgroundStars.layer.borderColor = UIColor.init(named: "Primary")?.cgColor
        
        confirmButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10

        doLocalizebleString()
        
        // MARK: - TapGestures UIimage (stars)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapStarOne))

        starOne.addGestureRecognizer(tap1)
        starOne.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tapStarTwo))

        starTwo.addGestureRecognizer(tap2)
        starTwo.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.tapStarThree))

        starThree.addGestureRecognizer(tap3)
        starThree.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.tapStarFor))

        starFor.addGestureRecognizer(tap4)
        starFor.isUserInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.tapStarFive))

        starFive.addGestureRecognizer(tap5)
        starFive.isUserInteractionEnabled = true
        
    }
    
    func doLocalizebleString() {
        
        titleModalView.title = NSLocalizedString("TitleRateModalView", comment: "")
        navBarButtonLabel.title = NSLocalizedString("NavBarButtonConfirm", comment: "")
        confirmButton.setTitle(NSLocalizedString("ConfirmButtonLabel", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("CancelButtonLabel", comment: ""), for: .normal)
        
        explainRateLabel.text = "\(NSLocalizedString("ExplainRateLabel", comment: ""))"
        
        if typeRate == RateType.skill {
            typeRateLabel.text = RateType.skill.description

        } else if typeRate == RateType.behaviour {
            typeRateLabel.text = RateType.behaviour.description
            
        } else {
            typeRateLabel.text = "Rate"
        }
        
    }
}

extension RateViewController {
    //This extension control the state of stars and the rate
    
    @objc func tapStarOne(sender: UITapGestureRecognizer) {
        starOne.image = UIImage(systemName: "star.fill")
        starTwo.image = UIImage(systemName: "star")
        starThree.image = UIImage(systemName: "star")
        starFor.image = UIImage(systemName: "star")
        starFive.image = UIImage(systemName: "star")
        Rate = 1
        }
    
    @objc func tapStarTwo(sender: UITapGestureRecognizer) {
        starOne.image = UIImage(systemName: "star.fill")
        starTwo.image = UIImage(systemName: "star.fill")
        starThree.image = UIImage(systemName: "star")
        starFor.image = UIImage(systemName: "star")
        starFive.image = UIImage(systemName: "star")
        Rate = 2
        }
    
    @objc func tapStarThree(sender: UITapGestureRecognizer) {
        starOne.image = UIImage(systemName: "star.fill")
        starTwo.image = UIImage(systemName: "star.fill")
        starThree.image = UIImage(systemName: "star.fill")
        starFor.image = UIImage(systemName: "star")
        starFive.image = UIImage(systemName: "star")
        Rate = 3
        }
    
    @objc func tapStarFor(sender: UITapGestureRecognizer) {
        starOne.image = UIImage(systemName: "star.fill")
        starTwo.image = UIImage(systemName: "star.fill")
        starThree.image = UIImage(systemName: "star.fill")
        starFor.image = UIImage(systemName: "star.fill")
        starFive.image = UIImage(systemName: "star")
        Rate = 4
        }
    
    @objc func tapStarFive(sender: UITapGestureRecognizer) {
        starOne.image = UIImage(systemName: "star.fill")
        starTwo.image = UIImage(systemName: "star.fill")
        starThree.image = UIImage(systemName: "star.fill")
        starFor.image = UIImage(systemName: "star.fill")
        starFive.image = UIImage(systemName: "star.fill")
        Rate = 5
        }
}
 
