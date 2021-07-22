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
                return "Australia"
                
            case .EuropeEast:
                return "Europe East"
            
            case .EuropeWest:
                return "Europe West"
            
            case .Russia:
                return "Russia"
            
            case .SEAsia:
                return "SE Asia"
            
            case .SouthAfrica:
                return "South Africa"
                
            case .SouthAmerica:
                return "South America"
            
            case .USEast:
                return "US East"
            
            case .USWest:
                return "US West"
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
