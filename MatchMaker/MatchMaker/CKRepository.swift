//
//  CKRepository.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 23/07/21.
//

import Foundation
import CloudKit
import UIKit

enum UserTable: CustomStringConvertible {
    case recordType, id, name, nickname, country, description, photo, selectedPlatforms, languages
    
    var description: String {
        switch self {
            case .recordType:
                return "User"
            case .id:
                return "id"
            case .name:
                return "name"
            case .nickname:
                return "nickname"
            case .country:
                return "country"
            case .description:
                return "description"
            case .photo:
                return "photo"
            case .selectedPlatforms:
                return "selectedPlatforms"
            case .languages:
                return "languages"
        }
    }
}

enum UserGamesTable: CustomStringConvertible {
    case recordType,userId, gameId, selectedPlatforms, selectedServers
    
    var description: String {
        switch self {
            case .recordType:
                return "UserGames"
            case .userId:
                return "userId"
            case .gameId:
                return "gameId"
            case .selectedPlatforms:
                return "selectedPlatforms"
            case .selectedServers:
                return "selectedServers"
        }
    }
}

public class CKRepository {
    static var user: User? //singleton user
    private static let container: CKContainer = CKContainer(identifier: "iCloud.MatchMaker")
    
    static func setOnboardingInfo(name: String, nickname: String, photo: UIImage?, photoURL: URL?, country: String, description: String, languages: [Languages], selectedPlatforms: [Platform], selectedGames: [Game]){
        
        //getUserId
        let id = getUserId()
        
        //storing user data at CloudKit
        storeUserData(id: id, name: name, nickname: nickname, country: country, description: description, photo: photoURL, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames, languages: languages)
        
        //creating user singleton
        user = User(id: id, name: name, nickname: nickname, photo: photo, country: country, description: description, behaviourRate: 0, skillRate: 0, languages: languages, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames)
    }
    
    private static func getUserId() -> String{
        var id: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        container.fetchUserRecordID { record, error in
            id = record?.recordName ?? ""
            semaphore.signal()
        }
        semaphore.wait()
        return "id\(id)"
    }
    
    private static func storeUserData(id: String, name: String, nickname: String, country: String, description: String, photo: URL?, selectedPlatforms: [Platform], selectedGames: [Game], languages: [Languages]){
        
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: UserTable.recordType.description, recordID: recordID)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(id as CKRecordValue?, forKey: UserTable.id.description)
        record.setObject(name as CKRecordValue?, forKey: UserTable.name.description)
        record.setObject(nickname as CKRecordValue?, forKey: UserTable.nickname.description)
        record.setObject(country as CKRecordValue?, forKey: UserTable.country.description)
        record.setObject(description as CKRecordValue?, forKey: UserTable.description.description)
        let languagesKeys = languages.map({ language in
            language.key
        })
        record.setObject(languagesKeys as CKRecordValue?, forKey: UserTable.languages.description)
        if let photoNotNil = photo {
            let photoAsset = CKAsset(fileURL: photoNotNil)
            record.setObject(photoAsset as CKRecordValue?, forKey: UserTable.photo.description)
        }
        let platformsIds = selectedPlatforms.map { platform in
            platform.key
        }
        record.setObject(platformsIds as CKRecordValue?, forKey: UserTable.selectedPlatforms.description)
        
        publicDB.save(record) { savedRecord, error in
            if error != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "couldnt store user data"), object: record)
            }
        }
        
        storeUserGamesData(userId: id, selectedGames: selectedGames)
    }
    
    private static func storeUserGamesData(userId: String, selectedGames: [Game]) {
        let publicDB = container.publicCloudDatabase
        for game in selectedGames {
            let recordID = CKRecord.ID(recordName: "\(userId)\(game.id)")
            let record = CKRecord(recordType: UserGamesTable.recordType.description, recordID: recordID)
            
            record.setObject(userId as CKRecordValue?, forKey: UserGamesTable.userId.description)
            record.setObject(game.id as CKRecordValue?, forKey: UserGamesTable.gameId.description)
            
            let platformsIds = game.selectedPlatforms.map { platform in
                platform.key
            }
            record.setObject(platformsIds as CKRecordValue?, forKey: UserGamesTable.selectedPlatforms.description)
            
            let selectedServers = game.selectedServers.map { server in
                server.key
            }
            record.setObject(selectedServers as CKRecordValue?, forKey: UserGamesTable.selectedServers.description)
            
            publicDB.save(record) { savedRecord, error in
                if error != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "couldnt store userGames data"), object: record)
                }
            }
        }
    }
    
    static func getUserById(id: String, completion: @escaping (User) -> Void){
        let publicDB = container.publicCloudDatabase
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: UserTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { result, error in
            let id = result?[0].value(forKey: UserTable.id.description) as! String
            let name = result?[0].value(forKey: UserTable.name.description) as! String
            let nickname = result?[0].value(forKey: UserTable.nickname.description) as! String
            var photo: UIImage? = nil
            if let ckAsset = result?[0].value(forKey: UserTable.photo.description) as? CKAsset {
                photo = ckAsset.toUIImage()
            }
            
            let description = result?[0].value(forKey: UserTable.description.description) as! String
            let country = result?[0].value(forKey: UserTable.country.description) as! String
            let selectedPlatforms = (result?[0].value(forKey: UserTable.selectedPlatforms.description) as! [String]).map { platform in
                Platform.getPlatform(key: platform)
            }
            let languages = (result?[0].value(forKey: UserTable.languages.description) as! [String]).map { language in
                Languages.getLanguage(language: language)
            }
            
            let gamesPredicate = NSPredicate(format: "userId == %@", id)
            let gamesQuery = CKQuery(recordType: UserGamesTable.recordType.description, predicate: gamesPredicate)
            
            publicDB.perform(gamesQuery, inZoneWith: nil) { results, error in
                var games: [Game] = [Game]()
                let allGames = Games.buildGameArray()
                if let userGames = results {
                    for userGame in userGames {
                        let gameId = Games.getGameIdInt(id: (userGame.value(forKey: UserGamesTable.gameId.description) as! String))
                        let gameSelectedPlatforms = (userGame.value(forKey: UserGamesTable.selectedPlatforms.description) as! [String]).map { platform in
                            Platform.getPlatform(key: platform)
                        }
                        let gameSelectedServersString = userGame.value(forKey: UserGamesTable.selectedServers.description) as! [String]
                        var gameSelectedServers: [Servers] = [Servers]()
                        
                        for g in gameSelectedServersString {
                            if let sv = allGames[gameId].serverType?.getServer(server: g) {
                                gameSelectedServers.append(sv)
                            }
                        }
                        
                        games.append(Game(id: "\(gameId)", name: allGames[gameId].name, description: allGames[gameId].description, platforms: allGames[gameId].platforms, servers: allGames[gameId].servers, selectedPlatforms: gameSelectedPlatforms, selectedServers: gameSelectedServers, image: allGames[gameId].image))
                        
                    }
                }
                let user = User(id: id, name: name, nickname: nickname, photo: photo, country: country, description: description, behaviourRate: 0, skillRate: 0, languages: languages, selectedPlatforms: selectedPlatforms, selectedGames: games)
                
                completion(user)
            }
        }
        
    }
}

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL!) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
