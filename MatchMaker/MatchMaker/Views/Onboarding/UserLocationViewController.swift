//
//  UserLocationViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 07/08/21.
//

import UIKit

protocol UserLocationDelegate: AnyObject {
    func didSelect(with location: Locations)
}

class UserLocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var cellIdentifier: String = "locationCell"
    
    private var selectedIndexPath: IndexPath? {
        guard let index = locations.firstIndex(of: selectedLocation) else { return nil }
        let indexPath = IndexPath(row: index, section: 0)
        return indexPath
    }
    
    weak var delegate: UserLocationDelegate?
    var locations: [Locations] = []
    var selectedLocation: Locations = .brazil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        locations = Locations.allCases
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
