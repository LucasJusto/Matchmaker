//
//  UserModel.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 23/07/21.
//

import Foundation
import UIKit

public struct Social {
    let id: String //iCloud ID
    let name: String //real name
    let nickname: String //in game name
    let photo: UIImage //profile picture
}

public class User {
    let id: String //iCloud ID
    var name: String //real name
    var nickname: String //in game name
    var photo: UIImage? //profile picture
    var country: String //where the user is playing from
    var description: String
    var behaviourRate: Double
    var skillRate: Double
    var selectedPlatforms: [Platform]
    var languages: [String]
    var selectedGames: [Game]
    var friends: [Social]
    var blocked: [Social]
    
    init(id: String, name: String, nickname: String, photo: UIImage?, country: String, description: String, behaviourRate: Double, skillRate: Double,languages: [String], selectedPlatforms: [Platform], selectedGames: [Game]){
        self.id = id
        self.name = name
        self.nickname = nickname
        self.photo = photo ?? nil
        self.country = country
        self.description = description
        self.behaviourRate = behaviourRate
        self.skillRate = skillRate
        self.languages = languages
        self.selectedPlatforms = selectedPlatforms
        self.selectedGames = selectedGames
        friends = [Social]()
        blocked = [Social]()
    }
}
