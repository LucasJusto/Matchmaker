//
//  OnboardingRegisterViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

class OnboardingRegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profile-image-cell") as? ProfileImageTableViewCell else {
                    return UITableViewCell()
            }
            
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            let stringId = indexPath.row == 1 ? "onboarding5NameLabel" : "onboarding5UsernameLabel"
                        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-field-cell") as? TextFieldTableViewCell else {
                    return UITableViewCell()
            }
            
            cell.setUp(title: NSLocalizedString(stringId, comment: "text field title"))
            
            return cell
        }
        
        if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-view-cell") else {
                    return UITableViewCell()
            }
            
            return cell
        }
        
        if indexPath.row == 4 || indexPath.row == 5 {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") as? SelectorTableViewCell else {
                    return UITableViewCell()
            }
            
            let stringId = indexPath.row == 4 ? "onboarding5LanguagesLabel" : "onboarding5PlatformsLabel"
            
            let items = indexPath.row == 4 ? ["English", "Spanish", "Portuguese"] : ["Playstation", "PC", "Xbox", "Mobile"]
            
            cell.setUp(title: NSLocalizedString(stringId, comment: "section title"), items: items)
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") else {
                return UITableViewCell()
        }
        
        return cell
    }



}
