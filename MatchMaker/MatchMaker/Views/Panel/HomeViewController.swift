//
//  ViewController.swift
//  MatchMaker_uikit
//
//  Created by Marcelo Diefenbach on 25/07/21.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications:[String] = ["friend", "message", "friend", "message"]
    
    @IBAction func discoverButtonView(_ sender: Any) {
        performSegue(withIdentifier: "toGameServers", sender: nil)
    }
    
    var games: [Game] = Games.buildGameArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let tabBarItems = self.tabBarController?.tabBar.items {
            if tabBarItems.count == 4 {
                tabBarItems[0].title = NSLocalizedString("tabBarPanel", comment: "Panel")
                tabBarItems[1].title = NSLocalizedString("tabBarSocial", comment: "Social")
                tabBarItems[2].title = NSLocalizedString("tabBarDiscover", comment: "Discover")
                tabBarItems[3].title = NSLocalizedString("tabBarProfile", comment: "Profile")
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        
//      This code change the top color of uitabelview
        var frame = self.view.bounds
        frame.origin.y = -frame.size.height
        let primary = UIView(frame: frame)
        primary.tag = 3
        primary.backgroundColor = UIColor(named: "Primary")
        self.tableView.addSubview(primary)

        let widthConstraint = NSLayoutConstraint(item: primary, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: primary, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)

        NSLayoutConstraint.deactivate(primary.constraints)
        NSLayoutConstraint.activate([
            widthConstraint, centerX
        ])
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return notifications.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Logo", for: indexPath) as? TopBrandTableViewCell else{
                return UITableViewCell()
            }
            cell.noSelectionStyle()
            return cell
            
        } else if indexPath.item == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopHome", for: indexPath) as? HomeTopTableViewCell else{
                return UITableViewCell()
            }
            cell.noSelectionStyle()
            return cell
            
        } else if indexPath.item == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MidHome", for: indexPath) as? HomeMidTableViewCell else{
                return UITableViewCell()
            }
            
            cell.gamesCollectionView.delegate = self
            cell.noSelectionStyle()
            return cell
            
            
//            this code will be used when we put notifications in this screen
//        } else if notifications[indexPath.item - 2] == "friend"{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestFriend", for: indexPath) as? RequestFriendTableViewCell else{
//                return UITableViewCell()
//            }
//            cell.Username.text = "@username"
//            cell.NotificationLabel.text = "(nome) \(NSLocalizedString("NotificationRequestFriendLabel", comment: ""))"
//            cell.noSelectionStyle()
//            return cell
//
//        } else if notifications[indexPath.item - 2] == "message"{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as? NewMessageTableViewCell else{
//                return UITableViewCell()
//            }
//
//            cell.nameLabel.text = "Nome do usuário"
//            cell.messageLabel.text = "Aqui vai o texto da mensagem"
//            cell.squareImage.image = Colocar a imagem de perfil da pessoa que é a notificação
//            cell.noSelectionStyle()
//            return cell
//
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.item == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            let game = games[0]
            performSegue(withIdentifier: "toGame", sender: game)

        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGame" {

            guard let game = sender as? Game else { return }
            
            let rootController = segue.destination as? UINavigationController
            let destination = rootController?.topViewController as? GameDetailViewController

            destination?.game = game
        }
        
        if segue.identifier == "toGameServers" {
            
            if let destination = segue.destination as? GameDetailsViewController {
                destination.delegate = self
                destination.game = games.first
            }
        }
    }
}

extension HomeViewController: RoundedRectangleCollectionViewDelegate {
    
    func didSelectRoundedRectangleModel(model: RoundedRectangleModel) {
        
        guard let game = model as? Game else { return }
        performSegue(withIdentifier: "toGame", sender: game)
    }
}

extension HomeViewController: GameSelectionDelegate {
    func updateGame(_ game: Game, isSelected: Bool) {
        self.tabBarController?.selectedIndex = 2
                
        let rootController = self.tabBarController?.selectedViewController as? UINavigationController
        
        let destination = rootController?.topViewController as? DiscoverViewController
        
        destination?.selectedGames = [game]
        
        destination?.updateAndReload()
    }
}
