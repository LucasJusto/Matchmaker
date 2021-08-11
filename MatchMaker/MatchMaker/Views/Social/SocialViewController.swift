//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class SocialViewController: UIViewController {
    
    // User data and searching
    var users: [User] = []
    var filteredUsers: [User] = []
    
    @IBOutlet weak var SearchBar: UISearchBar!

    //let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return SearchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return SearchBar.isFocused && !isSearchBarEmpty
    }
    
    @IBOutlet weak var discoverTableView: UITableView!
    
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
        
        filteredUsers = users
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        // Header appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Search Controller | uses extension
//        SearchBar.searchResultsUpdater = self
//        SearchBar.obscuresBackgroundDuringPresentation = false
        SearchBar.placeholder = "Search Users"
        definesPresentationContext = true

//        // Adding filter button to the search controller
        SearchBar.delegate = self
        SearchBar.showsBookmarkButton = true
        SearchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"), for: .bookmark, state: .normal)
        
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

extension SocialViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: User) -> Bool in
            return user.name.lowercased().contains(searchText.lowercased())
        }
        discoverTableView.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // SHOW FILTER SCREEN
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

  }

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
            
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendProfileCell", for: indexPath) as? SocialTableViewCell
        else {
            return UITableViewCell()
        }
        
        // Using sections to have a "rounded cell" which is actually a section
        let user: User
        if isFiltering {
            user = filteredUsers[indexPath.section]
        } else {
            user = users[indexPath.section]
        }
        
        cell.setup(url: user.photoURL, nameText: user.name, nickText: user.nickname, userGames: user.selectedGames)
        
        return cell
    }
    
}
