//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var users: [User] = []
    
    @IBOutlet weak var DiscoverTableView: UITableView!
    @IBOutlet weak var FiltersButton: UIButton!
    
    override func viewDidLoad() {
        
        //START MOCKED DATA
        var selectedGames1 = Games.games
        var selectedGames2 = Games.games
        
        selectedGames1.append(contentsOf: Games.games)
        selectedGames2.append(Games.games[0])
        
        let user1: User = User(id: "0", name: "1arselo difenbeck", nickname: "@shechello", photo: nil, country: "Brazil", description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: Games.games)
        
        users.append(user1)
        
        let user2: User = User(id: "0", name: "2arselo difenbeck", nickname: "@shechello", photo: nil, country: "Brazil", description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: selectedGames1)
        
        users.append(user2)
        
        let user3: User = User(id: "0", name: "3arselo difenbeck", nickname: "@shechello", photo: nil, country: "Brazil", description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: selectedGames2)
        
        users.append(user3)
        //END MOCKED DATA
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DiscoverTableView.delegate = self
        DiscoverTableView.dataSource = self
        
        FiltersButton.setTitle(NSLocalizedString("DiscoverFiltersButton", comment: "Filters button in Discover Screen"), for: .normal)
        
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
