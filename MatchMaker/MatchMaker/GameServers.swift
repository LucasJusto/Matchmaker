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
    
    var key: String {
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
    
    static func getServer(server: String) -> Servers {
        switch server {
            case "Australia":
                return self.Australia
            case "Europe East":
                return self.EuropeEast
                
            case "Europe West":
                return self.EuropeWest
                
            case "Russia":
                return self.Russia
                
            case "SE Asia":
                return self.SEAsia
                
            case "South Africa":
                return self.SouthAfrica
                
            case "South America":
                return self.SouthAmerica
                
            case "US East":
                return self.USEast
                
            case "US West":
                return self.USWest
            default:
                return self.USWest
        }
    }
}

enum LeagueOfLegendsServers: Servers, CustomStringConvertible, CaseIterable {
    
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
    
    var key: String {
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
                return "Latin America North"
                
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
    
    static func getServer(server: String) -> Servers {
        switch server {
            case "Brazil":
                return self.Brazil
                
            case "Europe Nordic & East":
                return self.EuropeNordicEast
                
            case "Europe West":
                return self.EuropeWest
                
            case "Japan":
                return self.Japan
                
            case "Korea":
                return self.Korea
                
            case "Latin America North":
                return self.LatinAmericaNorth
                
            case "Latin America South":
                return self.LatinAmericaSouth
                
            case "North America":
                return self.NorthAmerica
                
            case "Oceania":
                return self.Oceania
                
            case "Russia":
                return self.Russia
                
            case "Turkey":
                return self.Turkey
            default:
                return self.NorthAmerica
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
    
    var key: String {
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
    
    static func getServer(server: String) -> Servers {
        switch server {
            case "EU North":
                return self.EUNorth
                
            case "Australia":
                return self.Australia
                
            case "Chile":
                return self.Chile
                
            case "Dubai":
                return self.Dubai
                
            case "EU East":
                return self.EUEast
                
            case "EU West":
                return self.EUWest
                
            case "Hong Kong":
                return self.HongKong
                
            case "India East":
                return self.IndiaEast
                
            case "India West":
                return self.IndiaWest
                
            case "Japan":
                return self.Japan
                
            case "PW Guangdong":
                return self.PWGuangdong
                
            case "PW Shanghai":
                return self.PWShanghai
                
            case "PW Tianjin":
                return self.PWTianjin
                
            case "Peru":
                return self.Peru
                
            case "Poland":
                return self.Poland
                
            case "Singapore":
                return self.Singapore
                
            case "South Africa":
                return self.SouthAfrica
                
            case "South America":
                return self.SouthAmerica
                
            case "Spain":
                return self.Spain
                
            case "US East":
                return self.USEast
                
            case "US North Central":
                return self.USNorthCentral
                
            case "US South East":
                return self.USSouthEast
                
            case "US South West":
                return self.USSouthWest
                
            case "US West":
                return self.USWest
                
            default:
                return self.USNorthCentral
        }
    }
}
