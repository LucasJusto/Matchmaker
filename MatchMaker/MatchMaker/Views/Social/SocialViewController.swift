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
    
    @IBOutlet weak var socialTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var blockedToggle: UISegmentedControl!
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    
    func updateAndReload() {
        CKRepository.getUserId(completion: { userId in
            self.userId = userId
            guard let userId = self.userId else { return }
            CKRepository.getFriendsById(id: userId, completion: { results in
                self.friends = results
                self.filteredFriends = self.friends
                DispatchQueue.main.async {
                    self.socialTableView.reloadData()
                }
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateAndReload()
        
        socialTableView.delegate = self
        socialTableView.dataSource = self
        
        // Header appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Search Controller | uses extension
        searchBar.delegate = self
        
        // LocalizableString
        searchBar.placeholder = NSLocalizedString("SocialViewSearchUsers", comment: "Placeholder text in search bar")
        let segment1 = NSLocalizedString("SocialViewFriendsSectionToggle", comment: "Friend section title in the toggle between friends/blocked")
        blockedToggle.setTitle(segment1, forSegmentAt: 0)
        let segment2 = NSLocalizedString("SocialViewBlockedSectionToggle", comment: "Blocked section title in the toggle between friends/blocked")
        blockedToggle.setTitle(segment2, forSegmentAt: 1)
//        blockedToggle.selectedSegmentIndex
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocialViewController.listUpdated), name: NSNotification.Name("friendsTable.tableChanged.description"), object: nil)
    }
    
    @objc func listUpdated() {
        updateAndReload()
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

extension SocialViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter { (friend: Social) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        socialTableView.reloadData()
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
        
        // Using sections to have a "rounded cell" which is actually a section
        let friend: Social
        if isFiltering {
            friend = filteredFriends[indexPath.section]
        } else {
            friend = friends[indexPath.section]
        }
        
        if friend.isInvite != nil {
            if friend.isInviter == true {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentFriendRequestCell", for: indexPath) as? SocialTableViewSentRequestCell else { return UITableViewCell() }
                cell.setup(userId: friend.id, photoURL: friend.photoURL, name: friend.name, nickname: friend.nickname)
                cell.delegate = self
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedFriendRequestCell", for: indexPath) as? SocialTableViewReceivedRequestCell else { return UITableViewCell() }
            cell.setup(userId: friend.id, photoURL: friend.photoURL, name: friend.name, nickname: friend.nickname)
            cell.delegate = self
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendProfileCell", for: indexPath) as? SocialTableViewFriendCell else { return UITableViewCell() }
        cell.setup(url: friend.photoURL, nameText: friend.name, nickText: friend.nickname, userGames: friend.games!)
        return cell
    }
    
}

extension SocialViewController: SocialTableViewSentRequestCellDelegate, SocialTableViewReceivedRequestCellDelegate {

    func reloadTableView(_ sender: Any) {
        updateAndReload()
    }
    
}
