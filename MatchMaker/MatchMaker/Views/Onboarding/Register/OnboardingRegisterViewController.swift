//
//  OnboardingRegisterViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

class OnboardingRegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    enum OnboardingTagCategory: Int, CaseIterable {
        case languages
        case platforms
    }
    
    enum OnboardingFields: Int, CaseIterable {
        case profileImage
        case nameField
        case usernameField
        case descriptionField
        case languages
        case platforms
    
        var description: String {
            switch self {
                case .profileImage: return "Profile image"
                case .nameField: return "Name"
                case .usernameField: return "Username"
                case .descriptionField: return "Description"
                case .languages: return "Languages"
                case .platforms: return "Platforms"
            }
        }
    }
    
    let onboardingFields = OnboardingFields.allCases
    
    typealias TagOption = (option: String, isFavorite: Bool)
    
    var selectedTags: [String] = [] {
        didSet {
            print(selectedTags)
        }
    }
    
    var tagLanguages: [TagOption] = []
    var tagPlatforms: [TagOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpTagCategories()
    }
    
    private func setUpTagCategories() {
        let supportedLanguages = ["English", "Spanish", "Portuguese"]
        
        let supportedPlatforms = ["Playstation", "PC", "Xbox", "Mobile"]
        
        let allTagCategories = OnboardingTagCategory.allCases
        
        allTagCategories.forEach { category in
            switch category {
                
                case .languages:
                    let tagLanguages = supportedLanguages.map { TagOption(option: $0, isFavorite: false) }
                    self.tagLanguages = tagLanguages
                    
                case .platforms:
                    let tagPlatforms = supportedPlatforms.map { TagOption(option: $0, isFavorite: false) }
                    self.tagPlatforms = tagPlatforms
            }
        }
    }
}

extension OnboardingRegisterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onboardingFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let onboardingField = onboardingFields[indexPath.row]
        
        let defaultCell = UITableViewCell()
        
        switch onboardingField {
            case .profileImage: return profileImageCell()
                
            case .nameField: return textFieldCell(titleKey: "onboarding5NameLabel")
                
            case .usernameField: return textFieldCell(titleKey: "onboarding5UsernameLabel")
                
            case .descriptionField: return textViewCell()
                
            case .languages: return selectorCell(titleKey: "onboarding5LanguagesLabel", tag: OnboardingTagCategory.languages.rawValue) ?? defaultCell
                    
            case .platforms: return selectorCell(titleKey: "onboarding5PlatformsLabel", tag: OnboardingTagCategory.platforms.rawValue) ?? defaultCell
        }
    }
    
    func profileImageCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profile-image-cell") as? ProfileImageTableViewCell else {
                return UITableViewCell()
        }
        
        return cell
    }
    
    func textFieldCell(titleKey: String) -> UITableViewCell {
        let string = NSLocalizedString(titleKey, comment: "text field label")
                    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-field-cell") as? TextFieldTableViewCell else {
                return UITableViewCell()
        }
        
        cell.setUp(title: string)
        
        return cell
    }
    
    func textViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-view-cell") else {
                return UITableViewCell()
        }
        
        return cell
    }

    func selectorCell(titleKey: String, tag: Int) -> SelectorTableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selector-cell") as? SelectorTableViewCell
        
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        cell?.collectionView.tag = tag
        
        let string = NSLocalizedString(titleKey, comment: "selector cell label")

        cell?.setUp(title: string)
        
        return cell
    }
}

extension OnboardingRegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let onboardingTagCategory = OnboardingTagCategory(rawValue: collectionView.tag) else {
            return 0
        }
        
        switch onboardingTagCategory {
            case .languages: return tagLanguages.count
            case .platforms: return tagPlatforms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
        
        guard let onboardingTagCategory = OnboardingTagCategory(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
        
        switch onboardingTagCategory {
            case .languages:
                let supportedLanguage = tagLanguages[indexPath.row]
                collectionCell.labelView.text = supportedLanguage.option
                collectionCell.containerView.backgroundColor = supportedLanguage.isFavorite ? UIColor(named: "Primary") : .clear

                
            case .platforms:
                let supportedPlatform = tagPlatforms[indexPath.row]
                collectionCell.labelView.text = supportedPlatform.option
                collectionCell.containerView.backgroundColor = supportedPlatform.isFavorite ? UIColor(named: "Primary") : .clear
        }
                
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let onboardingTagCategory = OnboardingTagCategory(rawValue: collectionView.tag) else {
            return CGSize(width: 0, height: 0)
        }
        
        var model: String
        
        switch onboardingTagCategory {
            case .languages:
                model = tagLanguages[indexPath.row].option

            case .platforms:
                model = tagPlatforms[indexPath.row].option
        }
        
                
        let modelSize = model.size(withAttributes: nil)
        
        let size = CGSize(width: modelSize.width, height: collectionView.bounds.height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let onboardingTagCategory = OnboardingTagCategory(rawValue: collectionView.tag) else {
            return
        }
        
        switch onboardingTagCategory {
            case .languages:
                tagLanguages[indexPath.row].isFavorite.toggle()
            case .platforms:
                tagPlatforms[indexPath.row].isFavorite.toggle()
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}
