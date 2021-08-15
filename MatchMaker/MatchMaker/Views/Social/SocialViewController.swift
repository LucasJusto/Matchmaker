//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class SocialViewController: UIViewController {
    
    // User data and searching
    var userId: String?
    var friends: [Social] = []
    var filteredFriends: [Social] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var blockedToggle: UISegmentedControl!
    
    //let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchBar.isFocused && !isSearchBarEmpty
    }
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    override func viewDidLoad() {
        
        CKRepository.getUserId(completion: { userId in
            self.userId = userId
            guard let userId = self.userId else { return }
            CKRepository.getFriendsById(id: userId, completion: { results in
                self.friends = results
                print("aaaaae: \(results)")
            })
        })
        
        filteredFriends = friends
        
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
        searchBar.placeholder = "Search Users"
        definesPresentationContext = true

//        // Adding filter button to the search controller
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"), for: .bookmark, state: .normal)
        
        // LocalizableString
        blockedToggle.actionForSegment(at: 0)?.title = NSLocalizedString("SocialViewFriendsSectionToggle", comment: "Friend section title in the toggle between friends/blocked")
        blockedToggle.actionForSegment(at: 1)?.title = NSLocalizedString("SocialViewBlockedSectionToggle", comment: "Blocked section title in the toggle between friends/blocked")
        
        
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
        filteredFriends = friends.filter { (friend: Social) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
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
            return filteredFriends.count
        }
            
        return friends.count
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
        let friend: Social
        if isFiltering {
            friend = filteredFriends[indexPath.section]
        } else {
            friend = friends[indexPath.section]
        }
        var games: [Game] = []
        guard let games = friend.games else { return cell }
        cell.setup(url: friend.photoURL, nameText: friend.name, nickText: friend.nickname, userGames: games)
        
        return cell
    }
    
}
