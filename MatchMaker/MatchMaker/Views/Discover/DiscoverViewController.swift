//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    // User data and searching
    var users: [Social] = []
    var filteredUsers: [Social] = []
    
    // Segue helper
    var destinationUser: User?
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CKRepository.searchUsers(languages: [], platforms: [], behaviourRate: 0, skillRate: 0, locations: [], games: []) { asd in
            self.users = asd
            self.filteredUsers = asd
            DispatchQueue.main.async {
                self.discoverTableView.reloadData()
            }
        }
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        // Header appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Search Controller | uses extension
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Adding filter button to the search controller
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"), for: .bookmark, state: .normal)
        
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

extension DiscoverViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: Social) -> Bool in
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

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverProfileCell", for: indexPath) as? DiscoverTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        // Using sections to have a "rounded cell" which is actually a section
        let user: Social
        if isFiltering {
            user = filteredUsers[indexPath.section]
        } else {
            user = users[indexPath.section]
        }
        
        cell.setup(userId: user.id,url: user.photoURL, nameText: user.name, nickText: user.nickname, userGames: user.games!)
        
        return cell
    }
    
}

extension DiscoverViewController: DiscoverTableCellDelegate {
    
    func didRequestProfile(_ sender: UITableViewCell) {
        guard let cell = sender as? DiscoverTableViewCell else { return }
        guard let userId = cell.userId else { return }
        CKRepository.getUserById(id: userId, completion: { user in
            self.destinationUser = user
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toOtherProfile", sender: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toOtherProfile" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! OtherProfileViewController
            destination.user = self.destinationUser
        }
    }
}
