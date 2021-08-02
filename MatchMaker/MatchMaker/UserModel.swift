//
//  UserModel.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 23/07/21.
//

import Foundation
import UIKit

enum Languages: CustomStringConvertible {
    case portuguese, english, russian, chinese, japanese, german, spanish
    
    var description: String {
        switch self {
            case .portuguese:
                return NSLocalizedString("LanguagesPortuguese", comment: "portuguese")
            case .english:
                return NSLocalizedString("LanguagesEnglish", comment: "english")
            case .russian:
                return NSLocalizedString("LanguagesRussian", comment: "russian")
            case .chinese:
                return NSLocalizedString("LanguagesChinese", comment: "chinese")
            case .japanese:
                return NSLocalizedString("LanguagesJapanese", comment: "japanese")
            case .german:
                return NSLocalizedString("LanguagesGerman", comment: "german")
            case .spanish:
                return NSLocalizedString("LanguagesSpanish", comment: "spanish")
        }
    }
    
    var key: String {
        switch self {
            case .portuguese:
                return "LanguagesPortuguese"
            case .english:
                return "LanguagesEnglish"
            case .russian:
                return "LanguagesRussian"
            case .chinese:
                return "LanguagesChinese"
            case .japanese:
                return "LanguagesJapanese"
            case .german:
                return "LanguagesGerman"
            case .spanish:
                return "LanguagesSpanish"
        }
    }
    
    static func getLanguage(language: String) -> Languages {
        switch language {
            case "LanguagesPortuguese":
                return Languages.portuguese
            case "LanguagesEnglish":
                return Languages.english
            case "LanguagesRussian":
                return Languages.russian
            case "LanguagesChinese":
                return Languages.chinese
            case "LanguagesJapanese":
                return Languages.japanese
            case "LanguagesGerman":
                return Languages.german
            case "LanguagesSpanish":
                return Languages.spanish
            default:
                return Languages.english
        }
    }
}

public struct Social {
    let id: String //iCloud ID
    let name: String //real name
    let nickname: String //in game name
    let photo: UIImage //profile picture
}

public class User {
    let id: String //iCloud ID
    var name: String //real name
    var nickname: String //in game name
    var photo: UIImage //profile picture
    var country: String //where the user is playing from
    var description: String
    var behaviourRate: Double
    var skillRate: Double
    var selectedPlatforms: [Platform]
    var languages: [Languages]
    var selectedGames: [Game]
    var friends: [Social]
    var blocked: [Social]
    
    init(id: String, name: String, nickname: String, photo: UIImage?, country: String, description: String, behaviourRate: Double, skillRate: Double,languages: [Languages], selectedPlatforms: [Platform], selectedGames: [Game]){
        self.id = id
        self.name = name
        self.nickname = nickname
        self.photo = photo ?? UIImage(named: "photoDefault")!
        self.country = country
        self.description = description
        self.behaviourRate = behaviourRate
        self.skillRate = skillRate
        self.languages = languages
        self.selectedPlatforms = selectedPlatforms
        self.selectedGames = selectedGames
        friends = [Social]()
        blocked = [Social]()
    }
}
