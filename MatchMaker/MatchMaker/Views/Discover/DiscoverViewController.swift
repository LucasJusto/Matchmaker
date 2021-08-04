//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    let user1: User = User(id: "0", name: "marselo difenbeck", nickname: "@shechello", photo: nil, country: "Brazil", description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: Games.buildGameArray())
    
    var users: [User] = []
    
    @IBOutlet weak var DiscoverTableView: UITableView!
    
    override func viewDidLoad() {
        
        users.append(user1)
        
        users.append(user1)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DiscoverTableView.delegate = self
        DiscoverTableView.dataSource = self
        
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

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverProfileCell", for: indexPath) as? DiscoverTableViewCell
        else {
            return UITableViewCell()
        }
        
        // Using sections to have a "rounded cell" which is actually a section
        let user = users[indexPath.section]
        
        cell.setup(profileImage: user.photo, nameText: user.name, nickText: user.nickname, userGames: user.selectedGames)
        
        return cell
    }
    
}
