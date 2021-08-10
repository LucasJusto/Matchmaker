//
//  OnboardingRegisterViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 26/07/21.
//

import UIKit

protocol GameSelectionDelegate: AnyObject {
    func updateGame(_ game: Game, isSelected: Bool)
}

class OnboardingRegisterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapDone(_ sender: UIButton) {
        
        let isIncomplete = nameField.isEmpty || usernameField.isEmpty || selectedLocation.string.isEmpty || tagLanguages.filter { $0.isFavorite }.count < 1 || tagPlatforms.filter { $0.isFavorite }.count < 1
        
        didTapDone = true
                
        if isIncomplete {
            self.present(alertEmptyFields(), animated: true, completion: nil)
        } else {
            self.tableView.reloadData()
        }
        
        let languages = tagLanguages.filter { $0.isFavorite }.map { Languages.getLanguage(language: "Languages\($0.option)") }
        let platforms = tagPlatforms.filter { $0.isFavorite }.map { Platform.getPlatform(key: "Platform\($0.option == "PlayStation" ? "PS" : $0.option)") }
        let games = tagGames.filter { $0.isFavorite }.map { $0.option }
            
//        CKRepository.setOnboardingInfo(name: self.nameField, nickname: self.usernameField, photoURL: nil, location: Locations.africaNorth, description: self.descriptionField, languages: languages, selectedPlatforms: platforms, selectedGames: games)
    }
    
    func alertEmptyFields() -> UIAlertController {
        let title = NSLocalizedString("onboarding5AlertTitleLabel", comment: "alert title")
        
        let message = NSLocalizedString("onboarding5AlertTextLabel", comment: "alert text")
        
        let buttonLabel = NSLocalizedString("onboarding5AlertButtonLabel", comment: "alert text")
        
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: buttonLabel, style: .default, handler: { (action) -> Void in
            self.tableView.reloadData()
          })
        
        dialogMessage.addAction(ok)
        
        return dialogMessage
    }
    
    @objc func closeKeyboard(sender: Any) {
        self.view.endEditing(true)
    }
    
    var didTapDone = false
    
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
    
    var tagLanguages: [TagOption] = []
    var tagPlatforms: [TagOption] = []
    var tagGames: [GameOption] = []
    var nameField: String = ""
    var usernameField: String = ""
    var descriptionField: String = ""
    
    typealias UserLocation = (string: String, enum: Locations)
    var selectedLocation: UserLocation = UserLocation(string: Locations.africaNorth.description, enum: Locations.africaNorth)
    
    var imagePicker: ImagePickerManager = ImagePickerManager()
    var profileImageUrl: URL?
    
    var selectedGame: GameOption? {
        didSet {
            print(selectedGame)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "selectedGame" {
//
//            if let navController = segue.destination as? UINavigationController {
//
//                if let childVC = navController.topViewController as? GameDetailsViewController {
//
//                    if let game = selectedGame {
//                        childVC.game = game
//                    }
//
//                    childVC.delegate = self
//                }
//            }
//        }
        
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
        
        cell.userAvatarView.delegate = self
        
        cell.tag = OnboardingFields.profileImage.rawValue
        
        return cell
    }
    
    func textFieldCell(titleKey: String, tag: Int) -> UITableViewCell {
        
        let string = NSLocalizedString(titleKey, comment: "text field label")
                    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-field-cell") as? TextFieldTableViewCell
              else {
                return UITableViewCell()
        }
        
        cell.textField.delegate = self
        cell.textField.tag = tag
                
        cell.setUp(title: string)
        
        var text = ""
        
        if let onboardingTextField = OnboardingTextFields(rawValue: tag) {
            
            switch onboardingTextField {
                case .nameField: text = nameField
                case .usernameField: text = usernameField
            }
        }
        
        if didTapDone && text.isEmpty {
            cell.textField.borderColor = .red
            
        } else {
            cell.textField.borderColor = UIColor(named: "Primary")
        }
        
        return cell
    }
    
    func textViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "text-view-cell") as? TextViewTableViewCell else {
                return UITableViewCell()
        }
        
        cell.textViewField.delegate = self
        cell.textViewField.text = descriptionField
        cell.counterLabelView.text = "\(descriptionField.count)/300"
        cell.textViewField.addDoneButton(title: NSLocalizedString("onboarding5KeyboardButton", comment: "Keyboard done Button"), target: self, selector: #selector(closeKeyboard(sender:)))

        return cell
    }
    
    func pickerCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "picker-cell") as? PickerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.currentSelectionLabel.text = selectedLocation.string
        
        // FIXME: alterar para selectedLocation
        if didTapDone && selectedLocation.string.isEmpty {
            cell.buttonView.borderColor = .red
        } else {
            cell.buttonView.borderColor = UIColor(named: "Primary")
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
        
        if let height = cell?.collectionView.collectionViewLayout.collectionViewContentSize.height {
            cell?.collectionViewHeight.constant = height
        }
        
        var selections = 0
        
        if let onboardingTags = OnboardingTagCategory(rawValue: tag) {
            
            switch onboardingTags {
                case .languages: selections = tagLanguages.filter { $0.isFavorite }.count
                case .platforms: selections = tagPlatforms.filter { $0.isFavorite }.count
                default: return cell
            }
        }
        
        if didTapDone && selections == 0 {
            cell?.requiredLabel.isHidden = false
            
        } else {
            cell?.requiredLabel.isHidden = true
        }
                
        return cell
    }
    
    func gameCell() -> GamesSelectionTableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "game-selection-cell") as? GamesSelectionTableViewCell
        
        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        cell?.collectionView.tag = OnboardingTagCategory.games.rawValue
                
//        let lines = tagGames.count/3
//
//        let width = UIScreen.main.bounds.width * 0.31
//
//        let cellHeight = Double(width) * 1.37
//
//        let height = CGFloat(cellHeight * Double(lines))
        
        if let height = cell?.collectionView.collectionViewLayout.collectionViewContentSize.height {
            cell?.collectionViewHeight.constant = height
        }
                
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
                let width = collectionView.bounds.width * 0.31
                
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
                self.selectedGame = tagGames[indexPath.row]
                performSegue(withIdentifier: "selectedGame", sender: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension OnboardingRegisterViewController: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {
        self.descriptionField = textView.text ?? ""
    }

    func textViewDidChange(_ textView: UITextView) {
        let cell = tableView.cellForRow(at: IndexPath(row: OnboardingFields.descriptionField.rawValue, section: 0)) as? TextViewTableViewCell
        
        cell?.counterLabelView.text = "\(textView.text.count)/300"
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return textView.text.count + (text.count - range.length) <= 300
    }
}

extension OnboardingRegisterViewController: UserAvatarViewDelegate {
    func didChooseImage() {
        let cell = tableView.cellForRow(at: IndexPath(row: OnboardingFields.profileImage.rawValue, section: 0)) as? ProfileImageTableViewCell
    
        imagePicker.pickImage(self) { [unowned self] image, url in
            DispatchQueue.main.async {
                cell?.userAvatarView.contentImage.image = image
                self.profileImageUrl = url
            }
        }
    }
}

extension OnboardingRegisterViewController: GameSelectionDelegate {
    
    func updateGame(_ game: Game, isSelected: Bool) {
        let indexPath = IndexPath(row: OnboardingFields.games.rawValue, section: 0)

        let cell = tableView.cellForRow(at: indexPath) as? GamesSelectionTableViewCell
    
        guard let gameIndex = tagGames.firstIndex(where: { $0.option.id == game.id }) else {
            return
        }
        
        tagGames[gameIndex] = GameOption(option: game, isFavorite: isSelected)
        
        let collectionIndexPath = IndexPath(row: gameIndex, section: 0)
        
        cell?.collectionView.reloadItems(at: [collectionIndexPath])
    }
    
}

extension OnboardingRegisterViewController: PickerCellDelegate, UserLocationDelegate {
    
    func didSelect(with location: Locations) {
        selectedLocation.string = location.description
        selectedLocation.enum = location
        
        tableView.reloadData()
    }
    
    func didChooseLocation(_ sender: UITableViewCell) {
        performSegue(withIdentifier: "toUserLocations", sender: sender)
    }
}
