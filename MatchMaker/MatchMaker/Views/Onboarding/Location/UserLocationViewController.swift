//
//  UserLocationViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 07/08/21.
//

import UIKit
//MARK: - UserLocationDelegate Protocol

protocol UserLocationDelegate: AnyObject {
    /**
    The equivalent of a "backwards segue". In order to send information one screen back.
    
     
    - Parameters:
        - location: the user's selected location.
     
    - Returns: Void
     */
    func didSelect(with location: Locations)
}

//MARK: - UserLocationViewController Class

class UserLocationViewController: UIViewController {

    //MARK: UserLocationViewController Variables Setup
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: UserLocationDelegate?

    private var cellIdentifier: String = "locationCell"
    private var selectedIndexPath: IndexPath? {
        guard let index = locations.firstIndex(of: selectedLocation) else { return nil }
        let indexPath = IndexPath(row: index, section: 0)
        return indexPath
    }
    
    var locations: [Locations] = []
    var selectedLocation: Locations = .brazil
    
    //MARK: UserLocationViewController Class Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        locations = Locations.allCases
        
        self.title = NSLocalizedString("LocationModalTitle", comment: "This is the translation for 'LocationModalTitle' at the Profile Customization section of Localizable.strings")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func didTapUpperDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapBottomDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

//MARK: - UITableViewDelegate

extension UserLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let location = locations[indexPath.row]
        delegate?.didSelect(with: location)
        
        guard location != selectedLocation else { return }

        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        selectedLocation = location
    }
}

//MARK: - UITableViewDataSource

extension UserLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                
        cell.textLabel?.text = locations[indexPath.row].description
        
        let isCheckmarked = locations[indexPath.row] == selectedLocation
        cell.accessoryType = isCheckmarked ? .checkmark : .none
        
        return cell
    }
}
