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
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("filtersNavigationTitle", comment: "navigation title")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadData() {
        let needsLoading = [FilterOptions.languages, FilterOptions.platforms, FilterOptions.games]
        
        needsLoading.forEach { filter in
            switch filter {
                case .languages:
                    self.tagLanguages = Languages.allCases.map { TagOption(option: $0.description, isFavorite: false) }

                case .platforms:
                    self.tagPlatforms = Platform.allCases.map { TagOption(option: $0.description, isFavorite: false) }
                
                case .games:
                    let games = Games.buildGameArray()
                    self.selectedGames = games.map { GameOption(option: $0, isFavorite: false) }
//                case .behaviourRate:
//                    <#code#>
//                case .skillsRate:
//                    <#code#>
//                case .location:
//                    <#code#>
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

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell()
        
        let filter = FilterOptions.allCases[indexPath.row]
        
        return defaultCell
        
    }
}

extension FiltersViewController: UITableViewDelegate {}
