//
//  Games.swift
//  MatchMaker
//
//  Created by João Brentano on 22/07/21.
//
import Foundation
import UIKit

// MARK:- Platform
enum Platform: CustomStringConvertible {
    case PC
    case PlayStation
    case Xbox
    case Mobile
    
    var description: String {
        switch self {
            case .PC:
                return NSLocalizedString("PlatformPC", comment: "PC")
            case .PlayStation:
                return NSLocalizedString("PlatformPS", comment: "PlayStation")
            case .Xbox:
                return NSLocalizedString("PlatformXbox", comment: "Xbox")
            case .Mobile:
                return NSLocalizedString("PlatformMobile", comment: "Mobile")
        }
    }
}

protocol Servers {
    var description: String { get }
}

// MARK:- Game Struct
struct Game {
    let id: String
    let name: String
    let description: String
    let platforms: [Platform]
    let servers: [Servers]
    var selectedPlatforms: [Platform]
    var selectedServers: [Servers]
    let image: UIImage
}

// MARK:- Game Array Mocking
public class Games {
    let games: [Game] = buildGameArray()
    
    static func buildGameArray() -> [Game] {
        var games: [Game] = []
        // Dota 2
        games.append(Game(id: "0", name: "Dota 2", description: NSLocalizedString("Dota2Description", comment: "dota 2 desc"), platforms: [Platform.PC], servers: [Dota2Servers.USWest, Dota2Servers.USEast, Dota2Servers.EuropeWest, Dota2Servers.EuropeEast, Dota2Servers.SEAsia, Dota2Servers.SouthAmerica, Dota2Servers.Russia, Dota2Servers.Australia, Dota2Servers.SouthAfrica], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "Dota2")!))
        // League Of Legends
        games.append(Game(id: "1", name: "League of Legends", description: NSLocalizedString("LeagueOfLegendsDescription", comment: "LOL desc"), platforms: [Platform.PC, Platform.Mobile], servers: [LeagueOfLegendsServers.Brazil, LeagueOfLegendsServers.EuropeNordicEast, LeagueOfLegendsServers.EuropeWest, LeagueOfLegendsServers.LatinAmericaNorth, LeagueOfLegendsServers.LatinAmericaSouth, LeagueOfLegendsServers.NorthAmerica, LeagueOfLegendsServers.Oceania, LeagueOfLegendsServers.Russia, LeagueOfLegendsServers.Turkey, LeagueOfLegendsServers.Japan, LeagueOfLegendsServers.Korea], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "LeagueOfLegends")!))
        // Counter Strike: Global Offensive
        games.append(Game(id: "2", name: "Counter Strike: Global Offensive", description: NSLocalizedString("CounterStrikeGODescription", comment: "CSGO desc"), platforms: [Platform.PC], servers: [CounterStrikeGOServers.EUNorth, CounterStrikeGOServers.PWTianjin, CounterStrikeGOServers.Singapore, CounterStrikeGOServers.IndiaWest, CounterStrikeGOServers.Australia, CounterStrikeGOServers.EUWest, CounterStrikeGOServers.PWShanghai, CounterStrikeGOServers.Chile, CounterStrikeGOServers.USSouthEast, CounterStrikeGOServers.IndiaEast, CounterStrikeGOServers.EUEast, CounterStrikeGOServers.HongKong, CounterStrikeGOServers.Japan, CounterStrikeGOServers.Peru, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.PWGuangdong, CounterStrikeGOServers.USNorthCentral, CounterStrikeGOServers.USSouthWest, CounterStrikeGOServers.SouthAfrica, CounterStrikeGOServers.SouthAmerica, CounterStrikeGOServers.Spain, CounterStrikeGOServers.USEast, CounterStrikeGOServers.Dubai], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "CounterStrikeGO")!))
        return games
    }
}
