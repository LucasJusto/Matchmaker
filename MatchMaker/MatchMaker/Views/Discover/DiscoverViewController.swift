//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    let user1: User = User(id: "0", name: "name", nickname: "nick", photo: nil, country: "Brazil", description: "Description", behaviourRate: 10.0, skillRate: 10.0, languages: [Languages.english, Languages.portuguese], selectedPlatforms: [Platform.PC, Platform.PlayStation], selectedGames: Games.buildGameArray())
    
    var users: [User] = []
    
    @IBOutlet weak var DiscoverTableView: UITableView!
    
    override func viewDidLoad() {
        
        users.append(user1)
        
        super.viewDidLoad()
        DiscoverTableView.delegate = self
        DiscoverTableView.dataSource = self
        
        // Do any additional setup after loading the view.
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
        return 4
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        return view
//    }
    
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
        
        //indexPath.section
        
        cell.setup(profileImage: UIImage(named: "photoDefault")!, nameText: "João Brentano", nickText: "@shimmer", userGames: Games.games)
        return cell
    }
    
}
