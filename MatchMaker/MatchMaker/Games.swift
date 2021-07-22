//
//  Games.swift
//  MatchMaker
//
//  Created by João Brentano on 22/07/21.
//

import Foundation
import UIKit

enum Platforms {
    case PC
    case Playstation
    case Xbox
    case Mobile
}

protocol Servers {
    var description: String { get }
}

// MARK:- Game Struct
struct Game {
    let name: String
    let description: String
    let platform: [Platforms]
    let server: [Servers]
    var selectedPlatforms: [Platforms]
    var selectedServers: [Servers]
    let image: UIImage
}

// MARK:- Game Array Mocking
let games: [Game] = buildGameArray()

func buildGameArray() -> [Game] {
    var games: [Game] = []
    // Dota 2
    games.append(Game(name: "Dota 2", description: "Dota desc", platform: [Platforms.PC], server: [Dota2Servers.USWest, Dota2Servers.USEast, Dota2Servers.EuropeWest, Dota2Servers.EuropeEast, Dota2Servers.SEAsia, Dota2Servers.SouthAmerica, Dota2Servers.Russia, Dota2Servers.Australia, Dota2Servers.SouthAfrica], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "Dota2")!))
    // League Of Legends
    games.append(Game(name: "League of Legends", description: "LOL desc", platform: [Platforms.PC, Platforms.Mobile], server: [LeagueOfLegendsServers.Brazil, LeagueOfLegendsServers.EuropeNordicEast, LeagueOfLegendsServers.EuropeWest, LeagueOfLegendsServers.LatinAmericaNorth, LeagueOfLegendsServers.LatinAmericaSouth, LeagueOfLegendsServers.NorthAmerica, LeagueOfLegendsServers.Oceania, LeagueOfLegendsServers.Russia, LeagueOfLegendsServers.Turkey, LeagueOfLegendsServers.Japan, LeagueOfLegendsServers.Korea], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "LeagueOfLegends")!))
    // Counter Strike: Global Offensive
    games.append(Game(name: "Counter Strike: Global Offensive", description: "CSGO desc", platform: [Platforms.PC], server: [CounterStrikeGOServers.EUNorth, CounterStrikeGOServers.PWTianjin, CounterStrikeGOServers.Singapore, CounterStrikeGOServers.IndiaWest, CounterStrikeGOServers.Australia, CounterStrikeGOServers.EUWest, CounterStrikeGOServers.PWShanghai, CounterStrikeGOServers.Chile, CounterStrikeGOServers.USSouthEast, CounterStrikeGOServers.IndiaEast, CounterStrikeGOServers.EUEast, CounterStrikeGOServers.HongKong, CounterStrikeGOServers.Japan, CounterStrikeGOServers.Peru, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.PWGuangdong, CounterStrikeGOServers.USNorthCentral, CounterStrikeGOServers.USSouthWest, CounterStrikeGOServers.SouthAfrica, CounterStrikeGOServers.SouthAmerica, CounterStrikeGOServers.Spain, CounterStrikeGOServers.USEast, CounterStrikeGOServers.Dubai], selectedPlatforms: [], selectedServers: [], image: UIImage(named: "CounterStrikeGOServers")!))
    return games
}