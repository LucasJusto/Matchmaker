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
    case id, name, nickname, country, description, photo, selectedPlatforms
    
    var description: String {
        switch self {
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
        }
    }
}

enum UserGamesTable: CustomStringConvertible {
    case userId, gameId, selectedPlatforms
    
    var description: String {
        switch self {
            case .userId:
                return "userId"
            case .gameId:
                return "gameId"
            case .selectedPlatforms:
                return "selectedPlatforms"
        }
    }
}

public class CKRepository {
    static var user: User? //singleton user
    private static let container: CKContainer = CKContainer(identifier: "iCloud.MatchMaker")
    
    static func setOnboardingInfo(name: String, nickname: String, photo: UIImage?, photoURL: URL?, country: String, description: String, languages: [String], selectedPlatforms: [Platform], selectedGames: [Game]){
        
        //getUserId
        let id = getUserId()
        
        //storing user data at CloudKit
        storeUserData(id: id, name: name, nickname: nickname, country: country, description: description, photo: photoURL, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames)
        
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
    
    private static func storeUserData(id: String, name: String, nickname: String, country: String, description: String, photo: URL?, selectedPlatforms: [Platform], selectedGames: [Game]){
        
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: "User", recordID: recordID)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(id as CKRecordValue?, forKey: UserTable.id.description)
        record.setObject(name as CKRecordValue?, forKey: UserTable.name.description)
        record.setObject(nickname as CKRecordValue?, forKey: UserTable.nickname.description)
        record.setObject(country as CKRecordValue?, forKey: UserTable.country.description)
        record.setObject(description as CKRecordValue?, forKey: UserTable.description.description)
        if let photoNotNil = photo {
            let photoAsset = CKAsset(fileURL: photoNotNil)
            record.setObject(photoAsset as CKRecordValue?, forKey: UserTable.photo.description)
        }
        let platformsIds = selectedPlatforms.map { platform in
            platform.description
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
            let record = CKRecord(recordType: "UserGames", recordID: recordID)
            
            record.setObject(userId as CKRecordValue?, forKey: UserGamesTable.userId.description)
            record.setObject(game.id as CKRecordValue?, forKey: UserGamesTable.gameId.description)
            let platformsIds = game.selectedPlatforms.map { platform in
                platform.description
            }
            record.setObject(platformsIds as CKRecordValue?, forKey: UserGamesTable.selectedPlatforms.description)
            
            publicDB.save(record) { savedRecord, error in
                if error != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "couldnt store userGames data"), object: record)
                }
            }
        }
    }
}
