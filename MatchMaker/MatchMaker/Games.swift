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
        self.selectedServers = []
        self.selectedPlatforms = []
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
        let dota2 = Game(id: "0", name: "Dota 2", description: NSLocalizedString("Dota2Description", comment: "dota 2 desc"), platforms: [Platform.PC], servers: Dota2Servers.allCases, image: UIImage(named: "Dota2")!, serverType: Dota2Servers.self)
        
        // League Of Legends
        let lol = Game(id: "1", name: "League of Legends", description: NSLocalizedString("LeagueOfLegendsDescription", comment: "LOL desc"), platforms: [Platform.PC], servers: LeagueOfLegendsServers.allCases, image: UIImage(named: "LeagueOfLegends")!, serverType: LeagueOfLegendsServers.self)
        
        // Counter Strike: Global Offensive
        let cs = Game(id: "2", name: "Counter Strike: Global Offensive", description: NSLocalizedString("CounterStrikeGODescription", comment: "CSGO desc"), platforms: [Platform.PC], servers: CounterStrikeGOServers.allCases, image: UIImage(named: "CounterStrikeGO")!, serverType: CounterStrikeGOServers.self)
        
        // Wild Rift
        let wildRift = Game(id: "3", name: "League of Legends: Wild Rift", description: "Mergulhe no Wild Rift: a experiência de MOBA 5v5 cheia de habilidades e estratégias de League of Legends (e tudo feito do zero para dispositivos móveis e consoles!). Com controles novos e partidas aceleradas, jogadores de todos os níveis podem se unir aos amigos, escolher seus Campeões e fazer grandes jogadas.", platforms: [Platform.Mobile], servers: WildRiftServers.allCases, image: UIImage(named: "WildRift")!, serverType: WildRiftServers.self)
        
        games.append(dota2)
        games.append(lol)
        games.append(cs)
        games.append(wildRift)
        
        return games
    }
    
    static func getGameIdInt(id: String) -> Int{
        if let intId = Int(id) {
            return intId
        }
        return 0
    }
}
