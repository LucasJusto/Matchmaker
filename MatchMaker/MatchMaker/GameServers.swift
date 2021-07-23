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
            return "Brazil"
        case .EuropeNordicEast:
            return "Europe Nordic & East"
        case .EuropeWest:
            return "Europe West"
        case .Japan:
            return "Japan"
        case .Korea:
            return "Korea"
        case .LatinAmericaNorth:
            return "Lating America North"
        case .LatinAmericaSouth:
            return "Latin America South"
        case .NorthAmerica:
            return "North America"
        case .Oceania:
            return "Oceania"
        case .Russia:
            return "Russia"
        case .Turkey:
            return "Turkey"
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
            return "EU North"
        case .Australia:
            return "Australia"
        case .Chile:
            return "Chile"
        case .Dubai:
            return "Dubai"
        case .EUEast:
            return "EU East"
        case .EUWest:
            return "EU West"
        case .HongKong:
            return "Hong Kong"
        case .IndiaEast:
            return "India East"
        case .IndiaWest:
            return "India West"
        case .Japan:
            return "Japan"
        case .PWGuangdong:
            return "PW Guangdong"
        case .PWShanghai:
            return "PW Shanghai"
        case .PWTianjin:
            return "PW Tianjin"
        case .Peru:
            return "Peru"
        case .Poland:
            return "Poland"
        case .Singapore:
            return "Singapore"
        case .SouthAfrica:
            return "South Africa"
        case .SouthAmerica:
            return "South America"
        case .Spain:
            return "Spain"
        case .USEast:
            return "US East"
        case .USNorthCentral:
            return "US North Central"
        case .USSouthEast:
            return "US South East"
        case .USSouthWest:
            return "US South West"
        case .USWest:
            return "US West"
        }
    }
}
