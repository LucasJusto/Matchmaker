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
    case recordType, id, name, nickname, location, description, photo, selectedPlatforms, languages, averageBehaviourRate, averageSkillRate, storeFailMessage
    
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
            case .location:
                return "location"
            case .description:
                return "description"
            case .photo:
                return "photo"
            case .selectedPlatforms:
                return "selectedPlatforms"
            case .languages:
                return "languages"
            case .storeFailMessage:
                return "couldntStoreUserData"
            case .averageBehaviourRate:
                return "averageBehaviourRate"
            case .averageSkillRate:
                return "averageSkillRate"
        }
    }
}

enum UserGamesTable: CustomStringConvertible {
    case recordType,userId, gameId, selectedPlatforms, selectedServers, storeFailMessage
    
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
            case .storeFailMessage:
                return "couldntStoreUserGameData"
        }
    }
}

enum FriendsTable: CustomStringConvertible {
    case recordType, inviterId, receiverId, isInvite, storeFailMessage, tableChanged
    
    var description: String {
        switch self {
            case .recordType:
                return "Friends"
            case .inviterId:
                return "inviterId"
            case .receiverId:
                return "receiverId"
            case .isInvite:
                return "isInvite"
            case .storeFailMessage:
                return "couldntStoreFriendshipData"
            case .tableChanged:
                return "FriendsTableChanged"
        }
    }
}

enum BlockedTable: CustomStringConvertible {
    case recordType, userId, blockedId
    
    var description: String {
        switch self {
            case .recordType:
                return "Blocked"
            case .userId:
                return "userId"
            case .blockedId:
                return "blockedId"
        }
    }
}

public class CKRepository {
    static var user: User? //singleton user
    public static let container: CKContainer = CKContainer(identifier: "iCloud.MatchMaker")
    
    static func setOnboardingInfo(name: String, nickname: String, photoURL: URL?, location: Locations, description: String, languages: [Languages], selectedPlatforms: [Platform], selectedGames: [Game]){
        
        //getUserId
        CKRepository.getUserId { id in
            if let idNotNull = id {
                //storing user data at CloudKit
                storeUserData(id: idNotNull, name: name, nickname: nickname, location: location, description: description, photo: photoURL, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames, languages: languages)
                
                //creating user singleton
                user = User(id: idNotNull, name: name, nickname: nickname, photoURL: photoURL, location: location, description: description, behaviourRate: 0, skillRate: 0, languages: languages, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames)
            }
        }
    }
    
    static func setUserFromCloudKit() {
        CKRepository.getUserId { id in
            if let idNotNull = id {
                CKRepository.getUserById(id: idNotNull) { user in
                    CKRepository.user = user
                }
            }
        }
    }
    
    public static func getUserId(completion: @escaping (String?) -> Void) {
        container.fetchUserRecordID { record, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let id = record?.recordName {
                completion("id\(id)")
            }
        }
    }
    
    public static func isUserRegistered(completion: @escaping (Bool) -> Void) {
        var userID: String = ""
        
        CKRepository.getUserId { id in
            if let idNotNull = id {
                userID = idNotNull
            }
        }
        
        let publicDB = container.publicCloudDatabase
        let predicate = NSPredicate(format: "id == %@", userID)
        let query = CKQuery(recordType: UserTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { result, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if result?.count == 0 {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    private static func storeUserData(id: String, name: String, nickname: String, location: Locations, description: String, photo: URL?, selectedPlatforms: [Platform], selectedGames: [Game], languages: [Languages]){
        
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: UserTable.recordType.description, recordID: recordID)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(id as CKRecordValue?, forKey: UserTable.id.description)
        record.setObject(name as CKRecordValue?, forKey: UserTable.name.description)
        record.setObject(nickname as CKRecordValue?, forKey: UserTable.nickname.description)
        record.setObject(location.key as CKRecordValue?, forKey: UserTable.location.description)
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
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
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
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
            }
        }
    }
    
    static func getUserById(id: String, completion: @escaping (User) -> Void){
        let publicDB = container.publicCloudDatabase
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: UserTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { result, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if let resultNotNull = result {
                if resultNotNull.count > 0 {
                    let id = result?[0].value(forKey: UserTable.id.description) as! String
                    let name = result?[0].value(forKey: UserTable.name.description) as! String
                    let nickname = result?[0].value(forKey: UserTable.nickname.description) as! String
                    var photoURL: URL? = nil
                    if let ckAsset = result?[0].value(forKey: UserTable.photo.description) as? CKAsset {
                        photoURL = ckAsset.fileURL
                    }
                    var behaviourRate: Double?
                    if let bRate = result?[0].value(forKey: UserTable.averageBehaviourRate.description) as? Double {
                        behaviourRate = bRate
                    }
                    var skillRate: Double?
                    if let sRate = result?[0].value(forKey: UserTable.averageSkillRate.description) as? Double {
                        skillRate = sRate
                    }
                    let description = result?[0].value(forKey: UserTable.description.description) as! String
                    let location = Locations.getLocation(location: result?[0].value(forKey: UserTable.location.description) as! String)
                    let selectedPlatforms = (result?[0].value(forKey: UserTable.selectedPlatforms.description) as! [String]).map { platform in
                        Platform.getPlatform(key: platform)
                    }
                    let languages = (result?[0].value(forKey: UserTable.languages.description) as! [String]).map { language in
                        Languages.getLanguage(language: language)
                    }
                    
                    CKRepository.getUserGamesById(id: id) { games in
                        let user = User(id: id, name: name, nickname: nickname, photoURL: photoURL, location: location, description: description, behaviourRate: behaviourRate ?? 0, skillRate: skillRate ?? 0, languages: languages, selectedPlatforms: selectedPlatforms, selectedGames: games)
                        
                        completion(user)
                    }
                }
            }
        }
        
    }
    
    static func storeFriendship(inviterUserId: String, receiverUserId: String, isInvite: IsInvite, acceptance: Bool) {
        let recordID = CKRecord.ID(recordName:"\(inviterUserId)\(receiverUserId)")
        let record = CKRecord(recordType: FriendsTable.recordType.description, recordID: recordID)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(inviterUserId as CKRecordValue?, forKey: FriendsTable.inviterId.description)
        record.setObject(receiverUserId as CKRecordValue?, forKey: FriendsTable.receiverId.description)
        if isInvite == IsInvite.yes {
            record.setObject(IsInvite.yes.description as CKRecordValue?, forKey: FriendsTable.isInvite.description)
        }
        else if acceptance {
            record.setObject(IsInvite.no.description as CKRecordValue?, forKey: FriendsTable.isInvite.description)
        }
        else {
            deleteFriendship(id1: inviterUserId, id2: receiverUserId)
            return
        }
        
        publicDB.save(record) { record, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
        }
    }
    
    static func deleteFriendship(id1: String, id2: String) {
        let publicDB = container.publicCloudDatabase
        let recordID = CKRecord.ID(recordName:"\(id1)\(id2)")
        let recordID2 = CKRecord.ID(recordName:"\(id2)\(id1)")
        
        publicDB.delete(withRecordID: recordID) { id, error in
            if id != nil {
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
            }
        }
        
        publicDB.delete(withRecordID: recordID2) { id, error in
            if id != nil {
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
            }
        }
    }
    
    static func searchUsers(languages: [Languages], platforms: [Platform], behaviourRate: Double, skillRate: Double, locations: [Locations], games: [Game], completion: @escaping ([Social]) -> Void) {
        //creating user array to be returned
        var usersFound: [Social] = [Social]()
        getBlockedUsersId { blockedUsers in
            var blockedUsersId = blockedUsers
            //creating string to predicate (filtering the search)
            var fullPredicate = ""
            
            //if there is filters for languages: builds its predicate
            if languages.count > 0 {
                var languagesPredicate = "ANY { "
                for i in 0...languages.count-1 {
                    if i < languages.count-1 {
                        languagesPredicate += "'\(languages[i].key)', "
                    }
                    else {
                        languagesPredicate += "'\(languages[i].key)' } IN \(UserTable.languages.description)"
                    }
                }
                fullPredicate += "(\(languagesPredicate))"
                if platforms.count > 0 || locations.count > 0 || behaviourRate > 0 || skillRate > 0{
                    fullPredicate += " AND "
                }
            }
            
            //if there is filters for platforms: builds its predicate
            if platforms.count > 0 {
                var platformsPredicate = "ANY { "
                for i in 0...platforms.count-1 {
                    if i < platforms.count-1 {
                        platformsPredicate += "'\(platforms[i].key)', "
                    }
                    else {
                        platformsPredicate += "'\(platforms[i].key)' } IN \(UserTable.selectedPlatforms.description)"
                    }
                }
                fullPredicate += "(\(platformsPredicate))"
                if locations.count > 0 || behaviourRate > 0 || skillRate > 0{
                    fullPredicate += " AND "
                }
            }
            
            //if there is filters for locations: builds its predicate
            if locations.count > 0 {
                var locationsPredicate = "ANY { "
                for i in 0...locations.count-1 {
                    if i < locations.count-1 {
                        locationsPredicate += "'\(locations[i].key)', "
                    }
                    else {
                        locationsPredicate += "'\(locations[i].key)' }"
                    }
                }
                fullPredicate += "(\(locationsPredicate) = \(UserTable.location.description))"
                if behaviourRate > 0 || skillRate > 0 {
                    fullPredicate += " AND "
                }
            }
            
            if behaviourRate > 0 {
                fullPredicate += "(\(UserTable.averageBehaviourRate.description) >= \(behaviourRate))"
                if skillRate > 0 {
                    fullPredicate += " AND "
                }
            }
            
            if skillRate > 0 {
                fullPredicate += "(\(UserTable.averageSkillRate.description) >= \(skillRate))"
            }
            
            //creating necessary variables to use cloudkit
            let publicDB = container.publicCloudDatabase
            var predicate = NSPredicate(value: true)
            if languages.count > 0 || platforms.count > 0 || behaviourRate > 0 || skillRate > 0 || locations.count > 0 || games.count > 0 {
                //there is at least one filter
                predicate = NSPredicate(format: fullPredicate)
            }
            let query = CKQuery(recordType: UserTable.recordType.description, predicate: predicate)
            
            //filling the array with results to the search (filtered)
            publicDB.perform(query, inZoneWith: nil) { results, error in
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
                
                if let resultsNotNull = results {
                    if resultsNotNull.count > 0 {
                        for i in 0...resultsNotNull.count - 1 {
                            let id = resultsNotNull[i].value(forKey: UserTable.id.description) as! String
                            let name = resultsNotNull[i].value(forKey: UserTable.name.description) as! String
                            let nickName = resultsNotNull[i].value(forKey: UserTable.nickname.description) as! String
                            var photoURL: URL? = nil
                            if let ckAsset = resultsNotNull[i].value(forKey: UserTable.photo.description) as? CKAsset {
                                photoURL = ckAsset.fileURL
                            }
                            CKRepository.getUserGamesById(id: id) { userGames in
                                usersFound.append(Social(id: id, name: name, nickname: nickName, photoURL: photoURL, games: userGames, isInvite: nil))
                                if usersFound.count == resultsNotNull.count {
                                    //if usersFound is completlty filled
                                    
                                    //remove users that do not conform to the filter games
                                    usersFound = usersFound.filter { user in
                                        filterPerGames(filterBy: games, userGames: user.games ?? [])
                                    }
                                    
                                    if let u = CKRepository.user {
                                        blockedUsersId.append(u.id)
                                    }
                                    //if the user has blocked users
                                    if blockedUsersId.count > 0 {
                                        //remove them from the search
                                        usersFound = usersFound.filter({ user in
                                            !blockedUsersId.contains(user.id)
                                        })
                                    }
                                    
                                    completion(usersFound)
                                }
                            }
                        }
                    }
                    else {
                        //if not results return empty array
                        completion(usersFound)
                    }
                }
                else {
                    //if not results return empty array
                    completion(usersFound)
                }
            }
        }
    }
    
    private static func filterPerGames(filterBy: [Game], userGames: [Game]) -> Bool{
        if filterBy.count == 0 {
            //if there is no filter, return true for any comparison
            return true
        }
        
        let serversBool: Bool = false
        var platformsBool: Bool = false
        var idBool: Bool = false
        
        //check if each game has same id, servers or platforms
        for game in userGames {
            //checking if there is at least one equal game in both lists
            var currentFilterGame: Game?
            if filterBy.contains(where: { filterGame in
                if filterGame.id == game.id {
                    currentFilterGame = filterGame
                    return true
                }
                return false
            }) {
                idBool = true
                //if it has same game, check if it is played at same platform
                if currentFilterGame?.selectedPlatforms.count == 0 {
                    platformsBool = true
                }
                for platform in game.selectedPlatforms {
                    if currentFilterGame!.selectedPlatforms.contains(where: { filterPlatform in
                        filterPlatform.key == platform.key
                    }) {
                        platformsBool = true
                        break
                    }
                }
                if platformsBool {
                    if currentFilterGame?.selectedServers.count == 0 {
                        return true
                    }
                    //if at same game it is at same platform, checks if it is played at same server.
                    for server in game.selectedServers {
                        if currentFilterGame!.selectedServers.contains(where: { filterServer in
                            filterServer.key == server.key
                        }) {
                            //if it is same game played in same platforms and servers, return true (because it has to be included).
                            return true
                        }
                    }
                }
            }
            idBool = false
            platformsBool = false
        }
        
        return idBool && platformsBool && serversBool
    }
    
    private static func getUserGamesById(id: String, completion: @escaping ([Game]) -> Void) {
        let publicDB = container.publicCloudDatabase
        let gamesPredicate = NSPredicate(format: "userId == %@", id)
        let gamesQuery = CKQuery(recordType: UserGamesTable.recordType.description, predicate: gamesPredicate)
        
        publicDB.perform(gamesQuery, inZoneWith: nil) { results, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
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
            completion(games)
        }
    }
    
    static func getBlockedUsersId(completion: @escaping ([String]) -> Void) {
        var blockedUsersIds = [String]()
        
        let publicDB = container.publicCloudDatabase
        getUserId { id in
            if let idNotNull = id {
                let blockedPredicate = NSPredicate(format: "userId == %@", idNotNull)
                let blockedQuery = CKQuery(recordType: BlockedTable.recordType.description, predicate: blockedPredicate)
                publicDB.perform(blockedQuery, inZoneWith: nil) { results, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                    
                    if let resultsNotNull = results {
                        for result in resultsNotNull {
                            if let blockedUserId = result.value(forKey: BlockedTable.blockedId.description) as? String {
                                blockedUsersIds.append(blockedUserId)
                            }
                        }
                        completion(blockedUsersIds)
                    }
                    else {
                        //if there isnt results, return empty list
                        completion(blockedUsersIds)
                    }
                }
            }
            else {
                //if there isnt id, return empty list
                completion(blockedUsersIds)
            }
        }
    }
    
    static func errorAlertHandler(CKErrorCode: CKError.Code){
        
        let notLoggedInTitle = NSLocalizedString("CKErrorNotLoggedInTitle", comment: "Not logged in iCloud")
        let notLoggedInMessage = NSLocalizedString("CKErrorNotLoggedInMessage", comment: "You need to be logged in iCloud to use this app.")
        
        let defaultTitle = NSLocalizedString("CKErrorDefaultTitle", comment: "An error ocurred")
        let defaultMessage = NSLocalizedString("CKErrorDefaultMessage", comment: "Something unexpected ocurred, your data may not have been saved.")
        
        //getting the top view controller
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
            var topController = keyWindow?.rootViewController
                        
            // get topmost view controller to present alert
            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
            
            let isAlertOn = topController is UIAlertController
            
            guard !isAlertOn else { return }
            
            switch CKErrorCode {
                case .notAuthenticated:
                    //user is not logged in iCloud
                    print("ABOBORA \(topController)")
                    topController?.present(prepareAlert(title: notLoggedInTitle, message: notLoggedInMessage), animated: true)
                default:
                    topController?.present(prepareAlert(title: defaultTitle, message: defaultMessage), animated: true)
            }
        }
    }
    
    private static func prepareAlert(title: String, message: String) -> UIAlertController{
        let alertButtonLabel = NSLocalizedString("CKErrorAlertButtonLabel", comment: "Ok")
        
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: alertButtonLabel, style: .default, handler: { (action) -> Void in
            print("clickou pra fechar")
          })
        
        dialogMessage.addAction(ok)
        
        return dialogMessage
    }
}
