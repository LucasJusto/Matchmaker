//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    // MARK: - Filters
    var selectedLanguages: [Languages] = []
    var selectedPlatforms: [Platform] = []
    var behaviorsRate: Int = 0
    var skillsRate: Int = 0
    var selectedLocation: Locations?
    var selectedGames: [Game] = []
    
    // MARK: - User data and searching
    var users: [Social] = []
    var filteredUsers: [Social] = []
    
    // MARK: - Segue helper
    var destinationUser: User?
    
    // MARK: - Search
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func getSelectedLocations() -> [Locations] {
        if let selectedLocation = selectedLocation {
            return [selectedLocation]
        }
        return []
    }
    
    func updateAndReload() {
        CKRepository.searchUsers(languages: selectedLanguages, platforms: selectedPlatforms, behaviourRate: Double(behaviorsRate), skillRate: Double(skillsRate), locations: getSelectedLocations(), games: selectedGames) { result in
            
            self.users = result
            self.filteredUsers = result
            
            DispatchQueue.main.async {
                self.discoverTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("tabBarDiscover", comment: "Discover")
        updateAndReload()
        
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
        searchController.searchBar.placeholder = NSLocalizedString("DiscoverSearchBarPlaceholder", comment: "Discover")
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = UIColor(named: "Primary")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Adding filter button to the search controller
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"), for: .bookmark, state: .normal)
        
    }
}

extension DiscoverViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: Social) -> Bool in
            return user.name.lowercased().contains(searchText.lowercased())
        }
        discoverTableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "filter", sender: nil)
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

extension DiscoverViewController: DiscoverTableViewCellDelegate {
    func didPressShowProfileCollection(_ sender: DiscoverShowMoreCollectionViewCell) {
        guard let userId = sender.userId else { return }
        CKRepository.getUserById(id: userId, completion: { user in
            self.destinationUser = user
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toOtherProfile", sender: nil)
            }
        })
    }
    
    func didPressShowProfile(_ sender: DiscoverTableViewCell) {
        guard let userId = sender.userId else { return }
        CKRepository.getUserById(id: userId, completion: { user in
            self.destinationUser = user
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toOtherProfile", sender: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOtherProfile" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! OtherProfileViewController
            destination.user = self.destinationUser
            destination.discoverViewController = self
            for i in 0...(users.count - 1) {
                if users[i].id == self.destinationUser?.id {
                    destination.social = users[i]
                    break
                }
            }
        }
        
        if segue.identifier == "filter" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! FiltersViewController
            
            destination.delegate = self
            
            destination.loadData(languages: selectedLanguages, platforms: selectedPlatforms, behaviors: behaviorsRate, skills: skillsRate, location: selectedLocation, games: selectedGames)
        }
    }
}

extension DiscoverViewController: FiltersViewControllerDelegate {
    func setFilters(languages: [Languages], platforms: [Platform], behaviorsRate: Int, skillsRate: Int, selectedLocation: Locations?, selectedGames: [Game]) {

        self.selectedLanguages = languages
        self.selectedPlatforms = platforms
        self.behaviorsRate = behaviorsRate
        self.skillsRate = skillsRate
        self.selectedLocation = selectedLocation
        self.selectedGames = selectedGames

        updateAndReload()
    }
}
