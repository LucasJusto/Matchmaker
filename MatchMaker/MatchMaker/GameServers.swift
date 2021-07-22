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
