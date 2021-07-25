//
//  CKRepository.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 23/07/21.
//

import Foundation
import CloudKit
import UIKit

public class CKRepository {
    static var user: User? //singleton user
    private static let container: CKContainer = CKContainer(identifier: "iCloud.MatchMaker")
    
    static func setOnboardingInfo(name: String, nickname: String, photo: UIImage?, country: String, description: String, languages: [String], selectedPlatforms: [Platform], selectedGames: [Game]){
        //asks iCloud Permission
        let permission = iCloudPermission()
        
        
        if permission {
            //getUserId
            let id = getUserId()
            user = User(id: id, name: name, nickname: nickname, photo: photo ?? nil, country: country, description: description, behaviourRate: 0, skillRate: 0, languages: languages, selectedPlatforms: selectedPlatforms, selectedGames: selectedGames)
        }
    }
    
    private static func iCloudPermission() -> Bool {
        var hasICloudPermission = false
        DispatchQueue.global().sync {
            container.requestApplicationPermission(.userDiscoverability) { status, error in
                let cloudError = error as? CKError
                switch cloudError?.code {
                    case .notAuthenticated: print("dale")
                    default: print("nao dale")
                }
                hasICloudPermission = status == .granted
            }
        }
        return hasICloudPermission
    }
    
    private static func getUserId() -> String{
        var id: String = ""
        DispatchQueue.global().sync {
            container.fetchUserRecordID { record, error in
                id = record?.recordName ?? ""
            }
        }
        return id
    }
    
    private static func storeUserData(id: String, name: String, nickname: String, country: String, description: String, photo: UIImage?, selectedPlatforms: [Platform], selectedGames: [Game]){
        
    }
}
