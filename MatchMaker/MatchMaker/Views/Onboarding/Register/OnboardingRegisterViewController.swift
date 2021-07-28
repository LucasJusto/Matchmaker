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
    
    typealias TagCategory = (category: OnboardingTagCategory, tagOptions: [TagOption])
    
    var selectedTags: [String] = [] {
        didSet {
            print(selectedTags)
        }
    }
    
    var tagCategories: [TagCategory] = []
    
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
                    let tagCategory = TagCategory(category: category, tagOptions: supportedLanguages.map { TagOption(option: $0, isFavorite: false) })
                    tagCategories.append(tagCategory)
                    
                case .platforms:
                    let tagCategory = TagCategory(category: category, tagOptions: supportedPlatforms.map { TagOption(option: $0, isFavorite: false) })
                    tagCategories.append(tagCategory)
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
                
            case .languages: return selectorCell(titleKey: "onboarding5LanguagesLabel", tag: onboardingField.rawValue) ?? defaultCell
                    
            case .platforms: return selectorCell(titleKey: "onboarding5PlatformsLabel", tag: onboardingField.rawValue) ?? defaultCell
                
            default:
                return defaultCell
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
        
        cell?.delegate = self
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        cell?.collectionView.tag = tag
        
        let string = NSLocalizedString(titleKey, comment: "selector cell label")

        cell?.setUp(title: string)
        
        return cell
    }
}

extension OnboardingRegisterViewController: SelectorTableViewCellDelegate {
    
    func didTapTag(button: UIButton, sender: UITableViewCell) {
        
        let indexPath = tableView.indexPath(for: sender)
        tableView.reloadRows(at: [indexPath!], with: .fade)
        
        if let title = button.title(for: .normal) {
        
            if let index = selectedTags.firstIndex(of: title) {
                selectedTags.remove(at: index)
            } else {
                selectedTags.append(title)
            }
        }
    }
    
}

extension OnboardingRegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
//        switch tagCategories {
//            case 0: return supportedLanguages.count
//            case 1: return supportedPlatforms.count
//            default: return 0
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
        
        switch collectionView.tag {
            case 0:
                let supportedLanguage = supportedLanguages[indexPath.row]
                collectionCell.labelView.text = supportedLanguage
                
            case 1:
                let supportedPlatform = supportedPlatforms[indexPath.row]
                collectionCell.labelView.text = supportedPlatform
            
            default: break
        }
                
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = "indexpath: \(indexPath.row)"
        
        let modelSize = model.size(withAttributes: nil)
        
        let size = CGSize(width: modelSize.width, height: collectionView.bounds.height)
        
        return size
    }
    
    
}
