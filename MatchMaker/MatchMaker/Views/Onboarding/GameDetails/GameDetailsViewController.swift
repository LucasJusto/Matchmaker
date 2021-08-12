//
//  GameDetailsViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 08/08/21.
//

import UIKit

protocol GameSelectionDelegate: AnyObject {
    func updateGame(_ game: Game, isSelected: Bool)
}

class GameDetailsViewController: UIViewController {
    //MARK: - Typealias
    typealias TagOption = (option: String, isFavorite: Bool)

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameCoverView: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIStackView!
    
    //MARK: - var a serem recebidas
    weak var delegate: GameSelectionDelegate?
    var game: Game?
    var isGameSelected: Bool?
    
    //MARK: - var locais
    var platformTags: [TagOption] = []
    var serverTags: [TagOption] = []
    
    
    //sempre que forem modificados irao dar dismiss na tela
    var didTapDone: Bool = false {
        didSet {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var didTapDeselect: Bool = false {
        didSet {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Enum
    enum GameDetailsSections: Int, CaseIterable {
        case platforms
        case servers
        
        var description: String {
            switch self {
                case .platforms: return NSLocalizedString("onboarding5PlatformsLabel", comment: "Platforms label")
                case .servers: return NSLocalizedString("onboardingGameServersLabel", comment: "Servers label")
            }
        }
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let game = game {
            gameCoverView.image = game.image
        }
        
        if let isGameSelected = isGameSelected {
            doneButton.isHidden = isGameSelected
            buttonsContainerView.isHidden = !doneButton.isHidden
        }
        
        tableView.delegate = self
        tableView.dataSource = self
                
        setUpData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if var game = self.game {
            
            if didTapDeselect {
                
                game.selectedServers = []
                game.selectedPlatforms = []
                
                self.delegate?.updateGame(game, isSelected: false)
                
            } else {
                
                game.selectedServers = self.getSelectedServers()
                game.selectedPlatforms = self.getSelectedPlatforms()
                                
                if !game.selectedPlatforms.isEmpty && !game.selectedServers.isEmpty {
                    self.delegate?.updateGame(game, isSelected: true)
                }
            }
        }
    }
    
    func setUpData() {
        if let game = game {
            
            GameDetailsSections.allCases.forEach { section in
                
                switch section {
                    
                    case .platforms:
                        self.platformTags = game.platforms.map { TagOption(option: $0.description, isFavorite: game.platforms.count == 1 ? true : isPlatformSelected(platform: $0)) }
                        
                    case .servers:
                        self.serverTags = game.servers.map { TagOption(option: $0.description, isFavorite: game.servers.count == 1 ? true : isServerSelected(server: $0)) }
                }
            }
        }
    }
    
    func isPlatformSelected(platform: Platform) -> Bool {
        if let game = game {
            return game.selectedPlatforms.contains { $0 == platform }
        }
        
        return false
    }
    
    func isServerSelected(server: Servers) -> Bool {
        if let game = game {
            return game.selectedServers.contains { $0.description == server.description }
        }
        
        return false
    }
    
    @IBAction func didTapBarButton(_ sender: UIBarButtonItem) {
        self.didTapDone = true
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        self.didTapDone = true
    }
    
    @IBAction func didTapDone2(_ sender: UIButton) {
        self.didTapDone = true
    }
    
    @IBAction func didTapDeselect(_ sender: UIButton) {
        self.didTapDeselect = true
    }
    
    func getSelectedServers() -> [Servers] {
        let gameServerType = game?.serverType
        
        let selected = serverTags.filter { $0.isFavorite }.map { $0.option }
        
        let servers = selected.map { gameServerType?.getServer(server: $0) }
    
        return servers.compactMap { $0 }
    }
    
    func getSelectedPlatforms() -> [Platform] {
        let selected = platformTags.filter { $0.isFavorite }.map { $0.option }
        
        return selected.map { Platform.getPlatform(key: "Platform\($0 == "PlayStation" ? "PS" : $0)") }
    }
    
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension GameDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let gameDetailsSection = GameDetailsSections.allCases[indexPath.row]

        let defaultCell = UITableViewCell()

        switch gameDetailsSection {
            case .platforms:
                return selectorCell(tag: GameDetailsSections.platforms.rawValue) ?? defaultCell

            case .servers:
                return selectorCell(tag: GameDetailsSections.servers.rawValue) ?? defaultCell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameDetailsSections.allCases.count
    }

    //MARK: - Cell
    func selectorCell(tag: Int) -> SelectorTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") as? SelectorTableViewCell

        if let gameDetailsSection = GameDetailsSections(rawValue: tag) {

            cell?.setUp(title: gameDetailsSection.description)

            if gameDetailsSection == .platforms {
                let layout = cell?.collectionView.collectionViewLayout as! UICollectionViewFlowLayout

                layout.scrollDirection = .horizontal

                cell?.collectionView.setCollectionViewLayout(layout, animated: true)
            }
        }

        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        cell?.collectionView.tag = tag

        cell?.requiredLabel.isHidden = false
        cell?.requiredLabel.textColor = UIColor(named: "LightGray")

        //Setando a altura da cell e da tableView
        if let size = cell?.collectionView.collectionViewLayout.collectionViewContentSize {
            cell?.collectionViewHeight.constant = size.height

            let contentSize = tableView.contentSize.height + size.height
            tableViewHeight.constant = contentSize
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension GameDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let gameDetailsSection = GameDetailsSections.allCases[collectionView.tag]

        switch gameDetailsSection {
            case .platforms: return platformTags.count
            case .servers: return serverTags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let gameDetailsSection = GameDetailsSections.allCases[collectionView.tag]

        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell

        var tag: TagOption

        switch gameDetailsSection {
            case .platforms: tag = platformTags[indexPath.row]
            case .servers: tag = serverTags[indexPath.row]
        }

        collectionCell.labelView.text = tag.option

        collectionCell.containerView.backgroundColor = tag.isFavorite ? UIColor(named: "Primary") : .clear

        return collectionCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let gameDetailsSection = GameDetailsSections.allCases[collectionView.tag]

        switch gameDetailsSection {
            case .platforms:
                if platformTags.count != 1 {
                    platformTags[indexPath.row].isFavorite.toggle()
                }

            case .servers:
                if serverTags.count != 1 {
                    serverTags[indexPath.row].isFavorite.toggle()
                }
        }

        collectionView.reloadItems(at: [indexPath])
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension GameDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let gameDetailsSection = GameDetailsSections.allCases[collectionView.tag]

        var model: String

        switch gameDetailsSection {
            case .platforms:
                model = platformTags[indexPath.row].option

            case .servers:
                model = serverTags[indexPath.row].option
        }

        let modelSize = model.size(withAttributes: nil)

        let size = CGSize(width: modelSize.width, height: collectionView.bounds.height)

        return size
    }

}
