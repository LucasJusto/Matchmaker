//
//  GameServers.swift
//  MatchMaker
//
//  Created by João Brentano on 22/07/21.
//

import Foundation

enum Dota2Servers: Servers, CustomStringConvertible {
    
    case USWest
    case USEast
    case EuropeWest
    case EuropeEast
    case SEAsia
    case SouthAmerica
    case Russia
    case Australia
    case SouthAfrica
    
    var description: String {
        switch self {
            case .Australia:
                return NSLocalizedString("Australia", comment: "Australia")
                
            case .EuropeEast:
                return NSLocalizedString("Europe East", comment: "Europe East")
            
            case .EuropeWest:
                return NSLocalizedString("Europe West", comment: "Europe West")
            
            case .Russia:
                return NSLocalizedString("Russia", comment: "Russia")
            
            case .SEAsia:
                return NSLocalizedString("SE Asia", comment: "SE Asia")
                
            case .SouthAfrica:
                return NSLocalizedString("South Africa", comment: "South Africa")
                
            case .SouthAmerica:
                return NSLocalizedString("South America", comment: "South America")
            
            case .USEast:
                return NSLocalizedString("US East", comment: "US East")
            
            case .USWest:
                return NSLocalizedString("US West", comment: "US West")
        }
    }
}

enum LeagueOfLegendsServers: Servers, CustomStringConvertible {
    
    case Brazil
    case EuropeNordicEast
    case EuropeWest
    case LatinAmericaNorth
    case LatinAmericaSouth
    case NorthAmerica
    case Oceania
    case Russia
    case Turkey
    case Japan
    case Korea
    
    var description: String {
        switch self {
            case .Brazil:
                return NSLocalizedString("Brazil", comment: "Brazil")
                
            case .EuropeNordicEast:
                return NSLocalizedString("Europe Nordic & East", comment: "Europe Nordic & East")
                
            case .EuropeWest:
                return NSLocalizedString("Europe West", comment: "Europe West")
                
            case .Japan:
                return NSLocalizedString("Japan", comment: "Japan")
                
            case .Korea:
                return NSLocalizedString("Korea", comment: "Korea")
                
            case .LatinAmericaNorth:
                return NSLocalizedString("Latin America North", comment: "Latin America North")
                
            case .LatinAmericaSouth:
                return NSLocalizedString("Latin America South", comment: "Latin America South")
                
            case .NorthAmerica:
                return NSLocalizedString("North America", comment: "North America")
                
            case .Oceania:
                return NSLocalizedString("Oceania", comment: "Oceania")
                
            case .Russia:
                return NSLocalizedString("Russia", comment: "Russia")
                
            case .Turkey:
                return NSLocalizedString("Turkey", comment: "Turkey")
        }
    }
}

enum CounterStrikeGOServers: Servers, CustomStringConvertible {
    
    case EUNorth
    case PWTianjin
    case Singapore
    case IndiaWest
    case Australia
    case EUWest
    case PWShanghai
    case Chile
    case USSouthEast
    case IndiaEast
    case EUEast
    case HongKong
    case Japan
    case Peru
    case USWest
    case Poland
    case PWGuangdong
    case USNorthCentral
    case USSouthWest
    case SouthAfrica
    case SouthAmerica
    case Spain
    case USEast
    case Dubai
    
    var description: String {
        switch self {
            case .EUNorth:
                return NSLocalizedString("EU North", comment: "EU North")
                
            case .Australia:
                return NSLocalizedString("Australia", comment: "Australia")
            case .Chile:
                return NSLocalizedString("Chile", comment: "Chile")
                
            case .Dubai:
                return NSLocalizedString("Dubai", comment: "Dubai")
                
            case .EUEast:
                return NSLocalizedString("EU East", comment: "EU East")
                
            case .EUWest:
                return NSLocalizedString("EU West", comment: "EU West")
                
            case .HongKong:
                return NSLocalizedString("Hong Kong", comment: "Hong Kong")
                
            case .IndiaEast:
                return NSLocalizedString("India East", comment: "India East")
                
            case .IndiaWest:
                return NSLocalizedString("India West", comment: "India West")
                
            case .Japan:
                return NSLocalizedString("Japan", comment: "Japan")
                
            case .PWGuangdong:
                return NSLocalizedString("PW Guangdong", comment: "PW Guangdong")
                
            case .PWShanghai:
                return NSLocalizedString("PW Shanghai", comment: "PW Shanghai")
                
            case .PWTianjin:
                return NSLocalizedString("PW Tianjin", comment: "PW Tianjin")
                
            case .Peru:
                return NSLocalizedString("Peru", comment: "Peru")
                
            case .Poland:
                return NSLocalizedString("Poland", comment: "Poland")
            
            case .Singapore:
                return NSLocalizedString("Singapore", comment: "Singapore")
                
            case .SouthAfrica:
                return NSLocalizedString("South Africa", comment: "South Africa")
                
            case .SouthAmerica:
                return NSLocalizedString("South America", comment: "South America")
                
            case .Spain:
                return NSLocalizedString("Spain", comment: "Spain")
                
            case .USEast:
                return NSLocalizedString("US East", comment: "US East")
                
            case .USNorthCentral:
                return NSLocalizedString("US North Central", comment: "US North Central")
                
            case .USSouthEast:
                return NSLocalizedString("US South East", comment: "US South East")
                
            case .USSouthWest:
                return NSLocalizedString("US South West", comment: "US South West")
                
            case .USWest:
                return NSLocalizedString("US West", comment: "US West")
        }
    }
}
