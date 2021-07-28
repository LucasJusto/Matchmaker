//
//  OnboardingRegisterViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

class OnboardingRegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedTags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension OnboardingRegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func profileImageCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profile-image-cell") as? ProfileImageTableViewCell else {
                return UITableViewCell()
        }
        
        return cell
    }
    
    func textFieldCell(titleKey: String) -> UITableViewCell {
        let string = NSLocalizedString(titleKey, comment: "text field label")
                    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-field-cell") as? TextFieldTableViewCell else {
                return UITableViewCell()
        }
        
        cell.setUp(title: string)
        
        return cell
    }
    
    func textViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-view-cell") else {
                return UITableViewCell()
        }
        
        return cell
    }

    func selectorCell(titleKey: String) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") as? SelectorTableViewCell else {
                return UITableViewCell()
        }
        
        cell.delegate = self
        
//        let items = indexPath.row == 4 ? ["English", "Spanish", "Portuguese"] : ["Playstation", "PC", "Xbox", "Mobile"]
        
//            cell.tags.forEach { tag in
//                if let title = tag.title(for: .normal) {
//
//                    let selectedTag = selectedTags.contains(title)
//
//                    tag.backgroundColor = selectedTag ? UIColor(named: "Primary") : .clear
//                }
//            }
        let string = NSLocalizedString(titleKey, comment: "selector cell label")

        cell.setUp(title: string)
        
        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0: return profileImageCell()
                
            case 1: return textFieldCell(titleKey: "onboarding5NameLabel")
                
            case 2: return textFieldCell(titleKey: "onboarding5UsernameLabel")
                
            case 3: return textViewCell()
                
            case 4: return selectorCell(titleKey: "onboarding5LanguagesLabel")
                
            case 5: return selectorCell(titleKey: "onboarding5PlatformsLabel")
                
            default:
                return UITableViewCell()
        }
    }



}

extension OnboardingRegisterViewController: SelectorTableViewCellDelegate {
    func didTapTag(button: UIButton, sender: UITableViewCell) {
        //toggle
        let indexPath = tableView.indexPath(for: sender)
        print(indexPath)
        tableView.reloadRows(at: [indexPath!], with: .fade)
        selectedTags.append(button.title(for: .normal) ?? " ")
        
    }
}
