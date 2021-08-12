//
//  FiltersViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 12/08/21.
//

import UIKit

class FiltersViewController: UIViewController {
    
    //MARK: - Typealias
    typealias TagOption = (option: String, isFavorite: Bool)
    typealias GameOption = (option: Game, isFavorite: Bool)
    typealias UserLocation = (string: String, enum: Locations)
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var tagLanguages: [TagOption] = []
    var tagPlatforms: [TagOption] = []
    var behaviorsRate: Int = 0
    var skillsRate: Int = 0
    var selectedLocation: UserLocation = UserLocation(string: "-", enum: Locations.brazil)
    var selectedGames: [GameOption] = []
    var selectedGame: Game?
    
    //MARK: - Enums
    enum FilterOptions: Int, CaseIterable {
        case languages
        case platforms
        case behaviourRate
        case skillsRate
        case location
        case games
        
        var description: String {
            switch self {
                case .languages: return NSLocalizedString("filtersLanguagesLabel", comment: "Languages label")
                case .platforms: return NSLocalizedString("filtersPlatformsLabel", comment: "Platforms label")
                case .behaviourRate: return NSLocalizedString("filtersBehaviorsRatesLabel", comment: "Behaviors label")
                case .skillsRate: return NSLocalizedString("filtersSkillsRatesLabel", comment: "Skills rates label")
                case .location: return NSLocalizedString("filtersLocationsLabel", comment: "Locations label")
                case .games: return NSLocalizedString("filtersGamesLabel", comment: "Games label")
            }
        }
    }
    
    enum TagFilterOptions: Int, CaseIterable {
        case languages
        case platforms
        case games
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("filtersNavigationTitle", comment: "navigation title")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        TagFilterOptions.allCases.forEach { filter in
            switch filter {
                case .languages:
                    self.tagLanguages = Languages.allCases.map { TagOption(option: $0.description, isFavorite: false) }
                    
                case .platforms:
                    self.tagPlatforms = Platform.allCases.map { TagOption(option: $0.description, isFavorite: false) }
                    
                case .games:
                    let games = Games.buildGameArray()
                    self.selectedGames = games.map { GameOption(option: $0, isFavorite: false) }
            }
        }
    }
    
    @IBAction func didTapClean(_ sender: UIButton) {
        //funcao limpar filtros
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell()
        
        let filter = FilterOptions.allCases[indexPath.row]
        
        switch filter {
            case .languages: return selectorCell(title: filter.description, tag: TagFilterOptions.languages.rawValue) ?? defaultCell
            case .platforms: return selectorCell(title: filter.description, tag: TagFilterOptions.platforms.rawValue) ?? defaultCell
            case .behaviourRate:
                return defaultCell
            case .skillsRate:
                return defaultCell
            case .location:
                return defaultCell
            case .games:
                return defaultCell
        }
    }
    
    func selectorCell(title: String, tag: Int) -> SelectorTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") as? SelectorTableViewCell
        
        cell?.setUp(title: title)
        
        cell?.collectionView.tag = tag
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {}

// MARK: - UICollectionViewDataSource
extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let selectedTagFilter = TagFilterOptions(rawValue: collectionView.tag) else {
            return 0
        }
        
        switch selectedTagFilter {
            case .languages: return tagLanguages.count
            case .platforms: return tagPlatforms.count
            case .games: return selectedGames.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell = SelectableTagCollectionViewCell()
        
        guard let selectedTagFilter = TagFilterOptions(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
        
        if selectedTagFilter == .games {
            return collectionCell
            
        } else {
            
            collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
            
            var tagOption: TagOption?
            
            switch selectedTagFilter {
                case .languages: tagOption = tagLanguages[indexPath.row]
                case .platforms: tagOption = tagPlatforms[indexPath.row]
                case .games: break
            }
            
            if let tagOption = tagOption {
                collectionCell.labelView.text = tagOption.option
                collectionCell.containerView.backgroundColor = tagOption.isFavorite ? UIColor(named: "Primary") : .clear
            }
            
            return collectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let selectedTagFilter = TagFilterOptions(rawValue: collectionView.tag) else {
            return
        }

        switch selectedTagFilter {
            case .languages:
                if tagLanguages.count != 1 {
                    tagLanguages[indexPath.row].isFavorite.toggle()
                }
            case .platforms:
                if tagPlatforms.count != 1 {
                    tagPlatforms[indexPath.row].isFavorite.toggle()
                }
            case .games:
                return
        }

        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let selectedTagFilter = TagFilterOptions(rawValue: collectionView.tag) else {
            return CGSize(width: 0, height: 0)
        }

        var model: String

        switch selectedTagFilter {
            case .languages:
                model = tagLanguages[indexPath.row].option
            case .platforms:
                model = tagPlatforms[indexPath.row].option
            case .games:
                return CGSize(width: 0, height: 0)
        }

        let modelSize = model.size(withAttributes: nil)

        let size = CGSize(width: modelSize.width, height: collectionView.bounds.height)

        return size
    }

}

// MARK: - UICollectionViewDelegate
extension FiltersViewController: UICollectionViewDelegate {}
