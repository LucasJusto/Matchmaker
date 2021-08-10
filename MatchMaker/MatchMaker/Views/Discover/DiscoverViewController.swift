//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var users: [User] = []
    var filteredUsers: [User] = []
    
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        //START MOCKED DATA
        var selectedGames1 = Games.games
        var selectedGames2 = Games.games
        
        selectedGames1.append(contentsOf: Games.games)
        selectedGames2.append(Games.games[0])
        
        let user1: User = User(id: "0", name: "1arselo difenbeck", nickname: "@shechello", photoURL: nil, location: Locations.brazil, description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: Games.games)
        
        users.append(user1)
        
        let user2: User = User(id: "0", name: "2arselo difenbeck", nickname: "@shechello", photoURL: nil, location: Locations.brazil, description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: selectedGames1)
        
        users.append(user2)
        
        let user3: User = User(id: "0", name: "3arselo difenbeck", nickname: "@shechello", photoURL: nil, location: Locations.brazil, description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: selectedGames2)
        
        users.append(user3)
        //END MOCKED DATA
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self

        NSLocalizedString("DiscoverFiltersButton", comment: "Filters button in Discover Screen")
        
        // Header appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Search Controller | uses extension
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
//
//    //pesquisa
//    func updateFilters() {
//        // logica
//        DiscoverTableView.reloadData()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
      // TODO
    }
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

        cell.setup(url: user.photoURL, nameText: user.name, nickText: user.nickname, userGames: user.selectedGames)
        
        return cell
    }
    
}
