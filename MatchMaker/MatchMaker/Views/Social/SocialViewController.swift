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
    var blockedUsers: [Social] = []
    var filteredBlocked: [Social] = []
    
    // Segue helper
    var destinationUser: User?
    
    // Keyboard
    var keyboardIsShowing = false {
        didSet {
            searchBar.showsCancelButton = keyboardIsShowing
        }
    }
    
    @IBOutlet weak var socialTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var blockedToggle: UISegmentedControl!
    
    @IBAction func actionBlockedToggle(_ sender: UISegmentedControl) {
        DispatchQueue.main.async {
            self.socialTableView.reloadData()
        }
    }
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    
    func updateFriends(completion: @escaping () -> ()) {
        CKRepository.getUserId(completion: { userId in
            self.userId = userId
            guard let userId = self.userId else { return }
            CKRepository.getFriendsById(id: userId, completion: { results in
                
                var receivedRequest: [Social] = []
                var actualFriend: [Social] = []
                var sentRequest: [Social] = []
                
                for friend in results {
                    if friend.isInvite != nil {
                        if friend.isInviter == true {
                            sentRequest.append(friend)
                            continue
                        }
                        receivedRequest.append(friend)
                        continue
                    }
                    actualFriend.append(friend)
                }
                self.friends = []
                self.friends.append(contentsOf: receivedRequest)
                self.friends.append(contentsOf: actualFriend)
                self.friends.append(contentsOf: sentRequest)
                self.filteredFriends = self.friends
                completion()
            })
        })
    }
    
    func updateAndReloadFriends() {
        updateFriends {
            DispatchQueue.main.async {
                self.socialTableView.reloadData()
            }
        }
    }
    
    func updateBlocked(completion: @escaping () -> ()) {
        CKRepository.getBlockedUsersList(completion: { blocked in
            self.blockedUsers = blocked
            self.filteredBlocked = blocked
            completion()
        })
    }
    
    func updateAndReloadBlocked() {
        updateBlocked {
            DispatchQueue.main.async {
                self.socialTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateAndReloadFriends()
        updateBlocked{}
        self.title = NSLocalizedString("tabBarSocial", comment: "Social")
        
        socialTableView.delegate = self
        socialTableView.dataSource = self
        
        // Header appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Search Controller | uses extension
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.tintColor = UIColor(named: "Primary")
        
        // LocalizableString
        searchBar.placeholder = NSLocalizedString("SocialViewSearchUsers", comment: "Placeholder text in search bar")
        let segment1 = NSLocalizedString("SocialViewFriendsSectionToggle", comment: "Friend section title in the toggle between friends/blocked")
        blockedToggle.setTitle(segment1, forSegmentAt: 0)
        let segment2 = NSLocalizedString("SocialViewBlockedSectionToggle", comment: "Blocked section title in the toggle between friends/blocked")
        blockedToggle.setTitle(segment2, forSegmentAt: 1)
        blockedToggle.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocialViewController.listUpdated), name: NSNotification.Name(FriendsTable.tableChanged.description), object: nil)
    }
    
    @objc func listUpdated() {
        updateAndReloadBlocked()
        updateAndReloadFriends()
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.keyboardIsShowing = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.keyboardIsShowing = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.keyboardIsShowing = false
        self.searchBar.endEditing(true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if blockedToggle.selectedSegmentIndex == 0 {
            filteredFriends = friends.filter { (friend: Social) -> Bool in
                return friend.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredBlocked = blockedUsers.filter { (blocked: Social) -> Bool in
                return blocked.name.lowercased().contains(searchText.lowercased())
            }
        }
        socialTableView.reloadData()
    }

  }

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if blockedToggle.selectedSegmentIndex == 0 {
            if isFiltering {
                return filteredFriends.count
            }
            return friends.count
        }
        if isFiltering {
            return filteredBlocked.count
        }
        return blockedUsers.count
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
        
        if blockedToggle.selectedSegmentIndex == 1 {
            friend = blockedUsers[indexPath.section]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedCell", for: indexPath) as? SocialTableViewBlockedCell else { return UITableViewCell() }
            cell.setup(userId: friend.id, photoURL: friend.photoURL, name: friend.name, nickname: friend.nickname)
            cell.delegate = self
            return cell
        }
        
        if isFiltering {
            friend = filteredFriends[indexPath.section]
        } else {
            friend = friends[indexPath.section]
        }
        if let res = friend.isInvite {
            if res == IsInvite.yes {
                if friend.isInviter == true {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedFriendRequestCell", for: indexPath) as? SocialTableViewReceivedRequestCell else { return UITableViewCell() }
                    cell.setup(userId: friend.id, photoURL: friend.photoURL, name: friend.name, nickname: friend.nickname)
                    cell.delegate = self
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentFriendRequestCell", for: indexPath) as? SocialTableViewSentRequestCell else { return UITableViewCell() }
                cell.setup(userId: friend.id, photoURL: friend.photoURL, name: friend.name, nickname: friend.nickname)
                cell.delegate = self
                return cell
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendProfileCell", for: indexPath) as? SocialTableViewFriendCell else { return UITableViewCell() }
        cell.setup(userId: friend.id, url: friend.photoURL, nameText: friend.name, nickText: friend.nickname, userGames: friend.games!)
        cell.delegate = self
        return cell
    }
    
}

extension SocialViewController: SocialTableViewSentRequestCellDelegate, SocialTableViewReceivedRequestCellDelegate {

    func updateAndReload(_ sender: Any) {
        //update not necessary because of the silent notification integration
        //self.updateAndReloadFriends()
    }
    
}

extension SocialViewController: SocialTableViewBlockedCellDelegate {
    
    func updateAndReloadBlocked(_ sender: SocialTableViewBlockedCell) {
        //update not necessary because of the silent notification integration
        //self.updateAndReloadBlocked()
    }
    
}

extension SocialViewController: SocialTableViewFriendCellDelegate {
    
    func didPressShowProfileCollection(_ sender: SocialCollectionViewShowMoreCell) {
        guard let userId = sender.userId else { return }
        CKRepository.getUserById(id: userId, completion: { user in
            self.destinationUser = user
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toOtherProfile", sender: nil)
            }
        })
    }
    
    func didPressShowProfile(_ sender: SocialTableViewFriendCell) {
        guard let userId = sender.userId else { return }
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
            destination.socialViewController = self
            for i in 0...(friends.count - 1) {
                if friends[i].id == self.destinationUser?.id {
                    destination.social = friends[i]
                    break
                }
            }
        }
    }
}
