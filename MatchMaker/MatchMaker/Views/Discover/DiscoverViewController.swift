//
//  DiscoverViewController.swift
//  MatchMaker
//
//  Created by João Brentano on 29/07/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? DiscoverTableViewCell
        else {
            return UITableViewCell()
        }
        cell.setUp(profileImage: UIImage(named: "photoDefault")!, nameText: "João Brentano", nickText: "@shimmer")
        return cell
    }
    
    
}
