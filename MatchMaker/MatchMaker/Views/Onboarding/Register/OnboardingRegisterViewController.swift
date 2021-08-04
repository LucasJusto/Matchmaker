//
//  OnboardingRegisterViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

class OnboardingRegisterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapDone(_ sender: UIButton) {
        let languages = tagLanguages.filter { $0.isFavorite }.map { Languages.getLanguage(language: $0.option) }
        let platforms = tagPlatforms.filter { $0.isFavorite }.map { Platform.getPlatform(key: $0.option) }
        
        CKRepository.setOnboardingInfo(name: self.nameField, nickname: self.usernameField, photo: nil, photoURL: nil, location: Locations.africaNorth, description: self.descriptionField, languages: languages, selectedPlatforms: platforms, selectedGames: tagGames.map { $0.option })

        CKRepository.isUserSeted.wait()
    }
    
    enum OnboardingTagCategory: Int, CaseIterable {
        case languages
        case platforms
        case games
    }
    
    enum OnboardingTextFields: Int, CaseIterable {
        case nameField
        case usernameField
    }
    
    enum OnboardingFields: Int, CaseIterable {
        case profileImage
        case nameField
        case usernameField
        case descriptionField
        case locations
        case languages
        case platforms
        case games
    }
    
    let onboardingFields = OnboardingFields.allCases
    
    typealias TagOption = (option: String, isFavorite: Bool)
    
    typealias GameOption = (option: Game, isFavorite: Bool)
    
    var tagLanguages: [TagOption] = [] {
        didSet {
            print(tagLanguages)
        }
    }
    var tagPlatforms: [TagOption] = [] {
        didSet {
            print(tagPlatforms)
        }
    }
    var tagGames: [GameOption] = [] {
        didSet {
            print(tagGames)
        }
    }
    var nameField: String = "" {
        didSet {
            print(nameField)
        }
    }
    var usernameField: String = "" {
        didSet {
            print(usernameField)
        }
    }
    var descriptionField: String = "" {
        didSet {
            print(descriptionField)
        }
    }
    
    var location: String = "" {
        didSet {
            print(location)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
                
        setUpTagCategories()
    }
    
    private func setUpTagCategories() {
        let supportedLanguages = Languages.allCases.map { $0.description }
        
        let supportedPlatforms = Platform.allCases.map { $0.description }
        
        let supportedGames = Games.buildGameArray()
        
        let allTagCategories = OnboardingTagCategory.allCases
        
        allTagCategories.forEach { category in
            switch category {
                case .languages:
                    let tagLanguages = supportedLanguages.map { TagOption(option: $0, isFavorite: false) }
                    self.tagLanguages = tagLanguages
                    
                case .platforms:
                    let tagPlatforms = supportedPlatforms.map { TagOption(option: $0, isFavorite: false) }
                    self.tagPlatforms = tagPlatforms
                    
                case .games:
                    let tagGames = supportedGames.map { GameOption(option: $0, isFavorite: false) }
                    self.tagGames = tagGames
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
                
            case .nameField: return textFieldCell(titleKey: "onboarding5NameLabel", tag: OnboardingTextFields.nameField.rawValue)
                
            case .usernameField: return textFieldCell(titleKey: "onboarding5UsernameLabel", tag: OnboardingTextFields.usernameField.rawValue)
                
            case .descriptionField: return textViewCell()
                
            case .locations: return pickerCell()
                
            case .languages: return selectorCell(titleKey: "onboarding5LanguagesLabel", tag: OnboardingTagCategory.languages.rawValue) ?? defaultCell
                    
            case .platforms: return selectorCell(titleKey: "onboarding5PlatformsLabel", tag: OnboardingTagCategory.platforms.rawValue) ?? defaultCell
                
            case .games: return gameCell() ?? defaultCell
        }
    }
    
    func profileImageCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profile-image-cell") as? ProfileImageTableViewCell else {
                return UITableViewCell()
        }
        
        cell.tag = OnboardingFields.profileImage.rawValue
        
        return cell
    }
    
    func textFieldCell(titleKey: String, tag: Int) -> UITableViewCell {
        let string = NSLocalizedString(titleKey, comment: "text field label")
                    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-field-cell") as? TextFieldTableViewCell else {
                return UITableViewCell()
        }
        
        cell.textField.delegate = self
        cell.textField.tag = tag
                
        cell.setUp(title: string)
        
        return cell
    }
    
    func textViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-view-cell") as? TextViewTableViewCell else {
                return UITableViewCell()
        }
        
        cell.textViewField.delegate = self
                
        return cell
    }
    
    func pickerCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "picker-cell") as? PickerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.currentSelectionLabel.text = Locations.africaNorth.description
                
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
    
    func gameCell() -> GamesSelectionTableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "game-selection-cell") as? GamesSelectionTableViewCell
        
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        cell?.collectionView.tag = OnboardingTagCategory.games.rawValue
                
        let lines = tagGames.count/3
        
        let width = UIScreen.main.bounds.width * 0.28
        
        let cellHeight = Double(width) * 1.37
        
        let height = CGFloat(cellHeight * Double(lines))
        
        cell?.collectionViewHeight.constant = height
        
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
            case .games: return tagGames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let onboardingTagCategory = OnboardingTagCategory(rawValue: collectionView.tag) else {
            return UICollectionViewCell()
        }
    
        switch onboardingTagCategory {
            case .languages:
                let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
                
                let supportedLanguage = tagLanguages[indexPath.row]
                collectionCell.labelView.text = supportedLanguage.option
                collectionCell.containerView.backgroundColor = supportedLanguage.isFavorite ? UIColor(named: "Primary") : .clear
                return collectionCell

                
            case .platforms:
                
                let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-tag-cell", for: indexPath) as! SelectableTagCollectionViewCell
                
                let supportedPlatform = tagPlatforms[indexPath.row]
                collectionCell.labelView.text = supportedPlatform.option
                collectionCell.containerView.backgroundColor = supportedPlatform.isFavorite ? UIColor(named: "Primary") : .clear
                return collectionCell

            case .games:
                let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectable-image-cell", for: indexPath) as! SelectableImageCollectionViewCell
                
                let game = tagGames[indexPath.row]
                
                collectionCell.imageView.image = game.option.image
                collectionCell.selectionTag.isHidden = !game.isFavorite
                
                return collectionCell

        }
                
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
                
            case .games:
                let width = collectionView.bounds.width * 0.28
                
                return CGSize(width: width, height: width * 1.37)
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
                
            case .games:
                tagGames[indexPath.row].isFavorite.toggle()
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

extension OnboardingRegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let onboardingTextFieldTag = OnboardingTextFields(rawValue: textField.tag) else {
            return
        }
        
        switch onboardingTextFieldTag {
            case .nameField:
                self.nameField = textField.text ?? ""
            case .usernameField:
                self.usernameField = textField.text ?? ""
        }
        
    }
    
}

extension OnboardingRegisterViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.descriptionField = textView.text ?? ""
    }
    
}
