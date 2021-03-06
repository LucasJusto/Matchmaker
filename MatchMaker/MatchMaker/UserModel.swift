//
//  UserModel.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 23/07/21.
//

import Foundation
import UIKit

enum IsInvite: CustomStringConvertible {
    case yes, no
    
    var description: String {
        switch self {
            case .yes:
                return "yes"
            case .no:
                return "no"
        }
    }
    
    static func getIsInvite(string: String) -> IsInvite {
        switch string {
            case "yes":
                return IsInvite.yes
            case "no":
                return IsInvite.no
            default:
                return IsInvite.no
        }
    }
}

enum Languages: CustomStringConvertible, CaseIterable {
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
            case "Languages\(Languages.portuguese.description)":
                return Languages.portuguese
            case "Languages\(Languages.english.description)":
                return Languages.english
            case "Languages\(Languages.russian.description)":
                return Languages.russian
            case "Languages\(Languages.chinese.description)":
                return Languages.chinese
            case "Languages\(Languages.japanese.description)":
                return Languages.japanese
            case "Languages\(Languages.german.description)":
                return Languages.german
            case "Languages\(Languages.spanish.description)":
                return Languages.spanish
            default:
                return Languages.english
        }
    }
}


extension Languages: TitleModel { }

enum Locations: CustomStringConvertible, CaseIterable {
    case northAmerica, brazil, latinAmericaSouth, latinAmericaNorth, europeEast, europeWest, china, oceania, asiaEast, asiaWest, africaNorth, africaSouth, dontKnow
         
    var description: String {
        switch self {
            case .northAmerica:
                return NSLocalizedString("LocationNorthAmerica", comment: "North America")
            case .brazil:
                return NSLocalizedString("LocationBrazil", comment: "Brazil")
            case .latinAmericaSouth:
                return NSLocalizedString("LocationLatinAmericaSouth", comment: "Latin America South")
            case .latinAmericaNorth:
                return NSLocalizedString("LocationLatinAmericaNorth", comment: "Latin America North")
            case .europeEast:
                return NSLocalizedString("LocationEuropeEast", comment: "Europe East")
            case .europeWest:
                return NSLocalizedString("LocationEuropeWest", comment: "Europe West")
            case .china:
                return NSLocalizedString("LocationChina", comment: "China")
            case .oceania:
                return NSLocalizedString("LocationOceania", comment: "Oceania")
            case .asiaEast:
                return NSLocalizedString("LocationAsiaEast", comment: "Asia East")
            case .asiaWest:
                return NSLocalizedString("LocationAsiaWest", comment: "Asia West")
            case .africaNorth:
                return NSLocalizedString("LocationAfricaNorth", comment: "Africa North")
            case .africaSouth:
                return NSLocalizedString("LocationAfricaSouth", comment: "Africa South")
            case .dontKnow:
                return NSLocalizedString("LocationDontKnow", comment: "I don't know")
        }
    }
    
    var key: String {
        switch self {
            case .northAmerica:
                return "LocationNorthAmerica"
            case .brazil:
                return "LocationBrazil"
            case .latinAmericaSouth:
                return "LocationLatinAmericaSouth"
            case .latinAmericaNorth:
                return "LocationLatinAmericaNorth"
            case .europeEast:
                return "LocationEuropeEast"
            case .europeWest:
                return "LocationEuropeWest"
            case .china:
                return "LocationChina"
            case .oceania:
                return "LocationOceania"
            case .asiaEast:
                return "LocationAsiaEast"
            case .asiaWest:
                return "LocationAsiaWest"
            case .africaNorth:
                return "LocationAfricaNorth"
            case .africaSouth:
                return "LocationAfricaSouth"
            case .dontKnow:
                return "LocationDontKnow"
        }
    }
    
    static func getLocation(location: String) -> Locations {
        switch location {
            case "LocationNorthAmerica":
                return Locations.northAmerica
            case "LocationBrazil":
                return Locations.brazil
            case "LocationLatinAmericaSouth":
                return Locations.latinAmericaSouth
            case "LocationLatinAmericaNorth":
                return Locations.latinAmericaNorth
            case "LocationEuropeEast":
                return Locations.europeEast
            case "LocationEuropeWest":
                return Locations.europeWest
            case "LocationChina":
                return Locations.china
            case "LocationOceania":
                return Locations.oceania
            case "LocationAsiaEast":
                return Locations.asiaEast
            case "LocationAsiaWest":
                return Locations.asiaWest
            case "LocationAfricaNorth":
                return Locations.africaNorth
            case "LocationAfricaSouth":
                return Locations.africaSouth
            case "LocationDontKnow":
                return Locations.dontKnow
            default:
                return Locations.northAmerica
        }
    }
}

public class Social {
    let id: String //iCloud ID
    let name: String //real name
    let nickname: String //in game name
    let photoURL: URL? //profile picture
    var games: [Game]? //games played by this user
    var isInvite: IsInvite?
    var isInviter: Bool?
    
    init(id: String, name: String, nickname: String, photoURL: URL?, games: [Game]?, isInvite: IsInvite?, isInviter: Bool?) {
        
        self.id = id
        self.name = name
        self.nickname = nickname
        self.photoURL = photoURL
        self.games = games
        self.isInvite = isInvite
        self.isInviter = isInviter
    }
}

public class User {
    let id: String //iCloud ID
    var name: String //real name
    var nickname: String //in game name
    var photoURL: URL? //profile picture
    var location: Locations //where the user is playing from
    var description: String
    var behaviourRate: Double
    var skillRate: Double
    var selectedPlatforms: [Platform]
    var languages: [Languages]
    var selectedGames: [Game]
    var friends: [Social]
    var blocked: [Social]
    
    init(id: String, name: String, nickname: String, photoURL: URL?, location: Locations, description: String, behaviourRate: Double, skillRate: Double,languages: [Languages], selectedPlatforms: [Platform], selectedGames: [Game]){
        self.id = id
        self.name = name
        self.nickname = nickname
        self.photoURL = photoURL
        self.location = location
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
