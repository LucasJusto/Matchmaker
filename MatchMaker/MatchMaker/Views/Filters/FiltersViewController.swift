//
//  FiltersViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 12/08/21.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func setFilters(languages: [Languages], platforms: [Platform], behaviorsRate: Int, skillsRate: Int, selectedLocation: Locations?, selectedGames: [Game])
}

class FiltersViewController: UIViewController {
    
    // MARK: - Typealias
    typealias TagOption = (option: String, isFavorite: Bool)
    typealias GameOption = (option: Game, isFavorite: Bool)
    typealias UserLocation = (string: String, enum: Locations)
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneButton: LocalizableButtonLabel!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Variables to receive
    weak var delegate: FiltersViewControllerDelegate?
    
    // MARK: - Variables
    var tagLanguages: [TagOption] = []
    var tagPlatforms: [TagOption] = []
    var behaviorsRate: Int = 0
    var skillsRate: Int = 0
    var selectedLocation: UserLocation = UserLocation(string: "-", enum: Locations.brazil)
    var selectedGames: [GameOption] = []
    var selectedGame: GameOption?
    
    // MARK: - Enums
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
                case .behaviourRate: return NSLocalizedString("filtersBehaviorsRateLabel", comment: "Behaviors label")
                case .skillsRate: return NSLocalizedString("filtersSkillsRateLabel", comment: "Skills rates label")
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
    
    enum RateFilterOptions: Int, CaseIterable {
        case behaviourRate
        case skillsRate
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("filtersNavigationTitle", comment: "navigation title")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if isThereAnyFilter() {
            doneButton.isHidden = true
            buttonsStackView.isHidden = !doneButton.isHidden
        }
    }
    
    func isThereAnyFilter() -> Bool {
        let languages = tagLanguages.filter { $0.isFavorite }
        let platforms = tagPlatforms.filter { $0.isFavorite }
        let games = selectedGames.filter { $0.isFavorite }
        
        return !languages.isEmpty || !platforms.isEmpty || skillsRate >= 1 || behaviorsRate >= 1 || selectedLocation.string != "-" || games.count >= 1
    }
    
    func loadData(languages: [Languages], platforms: [Platform], behaviors: Int, skills: Int, location: Locations?, games: [Game]) {
    
        self.tagLanguages = Languages.allCases.map { TagOption(option: $0.description, isFavorite: languages.contains($0)) }
        
        self.tagPlatforms = Platform.allCases.map { TagOption(option: $0.description, isFavorite: platforms.contains($0)) }
        
        self.behaviorsRate = behaviors
        
        self.skillsRate = skills
        
        if let location = location {
            self.selectedLocation = UserLocation(string: location.description, enum: location)
        } else {
            self.selectedLocation = UserLocation(string: "-", enum: Locations.brazil)
        }
        
        let allGames = Games.buildGameArray()
        
        self.selectedGames = allGames.map { GameOption(option: $0, isFavorite: games.contains($0)) }
    }
    
    @IBAction func didTapClean(_ sender: UIButton) {
        
        for index in 0..<tagLanguages.count {
            tagLanguages[index].isFavorite = false
        }
        
        for index in 0..<tagPlatforms.count {
            tagPlatforms[index].isFavorite = false
        }

        self.behaviorsRate = 0
        self.skillsRate = 0
        
        self.selectedLocation = UserLocation(string: "-", enum: Locations.brazil)
    
        for index in 0..<selectedGames.count {
            selectedGames[index].isFavorite = false
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let languages = tagLanguages.filter { $0.isFavorite }.map { Languages.getLanguage(language: "Languages\($0.option)") }
        
        let platforms = tagPlatforms.filter { $0.isFavorite }.map { Platform.getPlatform(key: "Platform\($0.option == "PlayStation" ? "PS" : $0.option)") }
        
        let games = selectedGames.filter { $0.isFavorite }.map { $0.option }
                
        var location: Locations?
        
        if selectedLocation.string != "-" {
            location = selectedLocation.enum
        }
        
        delegate?.setFilters(languages: languages, platforms: platforms, behaviorsRate: behaviorsRate, skillsRate: skillsRate, selectedLocation: location, selectedGames: games)
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectedGame" {
            let rootVC = segue.destination as! UINavigationController
            let destination = rootVC.topViewController as! GameDetailsViewController
            
            destination.delegate = self
            
            if let game = selectedGame {
                destination.game = game.option
                destination.isGameSelected = game.isFavorite
            }
        }
        
        if segue.identifier == "toUserLocations" {
            let rootVC = segue.destination as! UINavigationController
            let destination = rootVC.topViewController as! UserLocationViewController
            
            destination.delegate = self
            destination.selectedLocation = selectedLocation.enum
        }
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell()
        
        let filter = FilterOptions.allCases[indexPath.row]
        
        switch filter {
            case .languages: return selectorCell(title: filter.description, tag: TagFilterOptions.languages.rawValue) ?? defaultCell
            case .platforms: return selectorCell(title: filter.description, tag: TagFilterOptions.platforms.rawValue) ?? defaultCell
            case .behaviourRate:
                return rateCell(title: filter.description, tag: RateFilterOptions.behaviourRate.rawValue) ?? defaultCell
            case .skillsRate:
                return rateCell(title: filter.description, tag: RateFilterOptions.skillsRate.rawValue) ?? defaultCell
            case .location:
                return pickerCell() ?? defaultCell
            case .games:
                return gameCell() ?? defaultCell
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
    
    func rateCell(title: String, tag: Int) -> RateTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rate-cell") as? RateTableViewCell
        
        var rate = 0

        if let rateFilter = RateFilterOptions(rawValue: tag) {
            switch rateFilter {
                case .behaviourRate:
                    rate = behaviorsRate
                case .skillsRate:
                    rate = skillsRate
            }
        }

        cell?.tag = tag
        cell?.delegate = self
        
        cell?.titleLabel.text = title
        cell?.currentRate = rate
        
        cell?.configure()
        
        return cell
    }
    
    func pickerCell() -> PickerTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picker-cell") as? PickerTableViewCell
        
        cell?.delegate = self
        cell?.currentSelectionLabel.text = selectedLocation.string
        
        return cell
    }
    
    func gameCell() -> GamesSelectionTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "game-selection-cell") as? GamesSelectionTableViewCell
        
        cell?.collectionView.tag = TagFilterOptions.games.rawValue
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        
        //Setando altura da CollectionView
        if let height = cell?.collectionView.collectionViewLayout.collectionViewContentSize.height {
            cell?.collectionViewHeight.constant = height
        }

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
        guard let selectedTagFilter = TagFilterOptions(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
        
        if selectedTagFilter == .games {
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-image-cell", for: indexPath) as! SelectableImageCollectionViewCell

            let game = selectedGames[indexPath.row]

            collectionCell.imageView.image = game.option.image

            collectionCell.selectionTag.isHidden = !game.isFavorite

            return collectionCell
            
        } else {
            
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
            
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
                //Seta um game selecionado e abre a tela de jogo selecionado
                self.selectedGame = selectedGames[indexPath.row]
                performSegue(withIdentifier: "selectedGame", sender: nil)
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
                let width = collectionView.bounds.width * 0.28

                return CGSize(width: width, height: width * 1.37)
        }

        let modelSize = model.size(withAttributes: nil)

        let size = CGSize(width: modelSize.width, height: collectionView.bounds.height)

        return size
    }

}

// MARK: - UICollectionViewDelegate
extension FiltersViewController: UICollectionViewDelegate {}

// MARK: - PickerCellDelegate and UserLocalitionDelegate
extension FiltersViewController: PickerCellDelegate, UserLocationDelegate {
    
    //MARK: UserLocationDelegate: Segue
    func didSelect(with location: Locations) {
        selectedLocation.string = location.description
        selectedLocation.enum = location
        
        tableView.reloadData()
    }
    
    //MARK: PickerCellDelegate: Segue
    func didChooseLocation(_ sender: UITableViewCell) {
        performSegue(withIdentifier: "toUserLocations", sender: sender)
    }
}

// MARK: - GameSelectionDelegate
extension FiltersViewController: GameSelectionDelegate {
    
    func updateGame(_ game: Game, isSelected: Bool) {
        let indexPath = IndexPath(row: FilterOptions.games.rawValue, section: 0)

        let cell = tableView.cellForRow(at: indexPath) as? GamesSelectionTableViewCell
    
        guard let gameIndex = selectedGames.firstIndex(where: { $0.option.id == game.id }) else {
            return
        }
        
        selectedGames[gameIndex] = GameOption(option: game, isFavorite: isSelected)
        
        let collectionIndexPath = IndexPath(row: gameIndex, section: 0)
        
        cell?.collectionView.reloadItems(at: [collectionIndexPath])
        
        if isThereAnyFilter() {
            doneButton.isHidden = true
        } else {
            doneButton.isHidden = false
        }
        
        buttonsStackView.isHidden = !doneButton.isHidden
    }
    
}

extension FiltersViewController: RateTableViewCellDelegate {
    
    func didTap(currentRate: Int, tag: Int) {
        guard let rateType = RateFilterOptions(rawValue: tag) else {
            return;
        }
        
        switch rateType {
            case .behaviourRate:
                behaviorsRate = currentRate
                
            case .skillsRate:
                skillsRate = currentRate
        }
    }
}
