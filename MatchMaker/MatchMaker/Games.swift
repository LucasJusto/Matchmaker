import Foundation
import UIKit

// MARK:- Platform
enum Platform: CustomStringConvertible, CaseIterable {
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
    
    var key: String {
        switch self {
            case .PC:
                return "PlatformPC"
            case .PlayStation:
                return "PlatformPS"
            case .Xbox:
                return "PlatformXbox"
            case .Mobile:
                return "PlatformMobile"
        }
    }
    
    var imageSelected: String {
        switch self {
            case .PC:
                return "PC_selected"
            case .PlayStation:
                return "Play_selected"
            case .Xbox:
                return "Xbox_selected"
            case .Mobile:
                return "Mobile_selected"
        }
    }
    
    var imageNotSelected: String {
        switch self {
            case .PC:
                return "PC"
            case .PlayStation:
                return "Play"
            case .Xbox:
                return "Xbox"
            case .Mobile:
                return "Mobile"
        }
    }
    
    static func getPlatform(key: String) -> Platform {
        switch key {
            case "PlatformPC":
                return Platform.PC
            case "PlatformPS":
                return Platform.PlayStation
            case "PlatformXbox":
                return Platform.Xbox
            case "PlatformMobile":
                return Platform.Mobile
            default:
                return Platform.PC
        }
    }
}

extension Platform: SmallLabeledImageModel { }

//MARK: - Servers: Protocol

protocol Servers {
    var description: String { get }
    
    var key: String { get }
    
    static func getServer(server: String) -> Servers
}

// MARK: - Game: Struct
struct Game {
    let id: String
    let name: String
    let description: String
    let platforms: [Platform]
    let servers: [Servers]
    var selectedPlatforms: [Platform]
    var selectedServers: [Servers]
    let image: UIImage
    var serverType: Servers.Type?
    
    public init(id: String, name: String, description: String, platforms: [Platform], servers: [Servers], image: UIImage, serverType: Servers.Type) {
        //init for app games
        self.id = id
        self.name = name
        self.description = description
        self.platforms = platforms
        self.servers = servers
        self.selectedServers = servers
        self.selectedPlatforms = platforms
        self.image = image
        self.serverType = serverType
    }
    
    public init(id: String, name: String, description: String, platforms: [Platform], servers: [Servers], selectedPlatforms: [Platform], selectedServers: [Servers],image: UIImage) {
        //init for user games
        self.id = id
        self.name = name
        self.description = description
        self.platforms = platforms
        self.servers = servers
        self.selectedServers = selectedServers
        self.selectedPlatforms = selectedPlatforms
        self.image = image
    }
}

extension Game: RoundedRectangleModel { }


// MARK:- Game Array Mocking
public class Games {
    static let games: [Game] = buildGameArray()
    
    static func buildGameArray() -> [Game] {
        var games: [Game] = []
        
        // Dota 2
        games.append(Game(id: "0", name: "Dota 2", description: NSLocalizedString("Dota2Description", comment: "dota 2 desc"), platforms: [Platform.PC], servers: [Dota2Servers.USWest, Dota2Servers.USEast, Dota2Servers.EuropeWest, Dota2Servers.EuropeEast, Dota2Servers.SEAsia, Dota2Servers.SouthAmerica, Dota2Servers.Russia, Dota2Servers.Australia, Dota2Servers.SouthAfrica], image: UIImage(named: "Dota2")!, serverType: Dota2Servers.self))
        
        // League Of Legends
        games.append(Game(id: "1", name: "League of Legends", description: NSLocalizedString("LeagueOfLegendsDescription", comment: "LOL desc"), platforms: [Platform.PC, Platform.Mobile], servers: [LeagueOfLegendsServers.Brazil, LeagueOfLegendsServers.EuropeNordicEast, LeagueOfLegendsServers.EuropeWest, LeagueOfLegendsServers.LatinAmericaNorth, LeagueOfLegendsServers.LatinAmericaSouth, LeagueOfLegendsServers.NorthAmerica, LeagueOfLegendsServers.Oceania, LeagueOfLegendsServers.Russia, LeagueOfLegendsServers.Turkey, LeagueOfLegendsServers.Japan, LeagueOfLegendsServers.Korea], image: UIImage(named: "LeagueOfLegends")!, serverType: LeagueOfLegendsServers.self))
        
        // Counter Strike: Global Offensive
        games.append(Game(id: "2", name: "Counter Strike: Global Offensive", description: NSLocalizedString("CounterStrikeGODescription", comment: "CSGO desc"), platforms: [Platform.PC, Platform.PlayStation, Platform.Xbox], servers: [CounterStrikeGOServers.EUNorth, CounterStrikeGOServers.PWTianjin, CounterStrikeGOServers.Singapore, CounterStrikeGOServers.IndiaWest, CounterStrikeGOServers.Australia, CounterStrikeGOServers.EUWest, CounterStrikeGOServers.PWShanghai, CounterStrikeGOServers.Chile, CounterStrikeGOServers.USSouthEast, CounterStrikeGOServers.IndiaEast, CounterStrikeGOServers.EUEast, CounterStrikeGOServers.HongKong, CounterStrikeGOServers.Japan, CounterStrikeGOServers.Peru, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.USWest, CounterStrikeGOServers.Poland, CounterStrikeGOServers.PWGuangdong, CounterStrikeGOServers.USNorthCentral, CounterStrikeGOServers.USSouthWest, CounterStrikeGOServers.SouthAfrica, CounterStrikeGOServers.SouthAmerica, CounterStrikeGOServers.Spain, CounterStrikeGOServers.USEast, CounterStrikeGOServers.Dubai], image: UIImage(named: "CounterStrikeGO")!, serverType: CounterStrikeGOServers.self))
        
        return games
    }
    
    static func getGameIdInt(id: String) -> Int{
        if let intId = Int(id) {
            return intId
        }
        return 0
    }
}
