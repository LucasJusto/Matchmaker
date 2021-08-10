//
//  AppDelegate.swift
//  MatchMaker
//
//  Created by Lucas Dimer Justo on 20/07/21.
//

import UIKit
import CloudKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.registerForRemoteNotifications()
        
        if UserDefaults.standard.bool(forKey: "FriendsTableSubscription") {
            
        } else {
            CKRepository.getUserId { id in
                if let idNotNull = id {
                    // 1. Create a Query Subscription used on iCloud to filter what shoud be triggered when record type changes
                    let newSubscription = CKQuerySubscription(recordType: FriendsTable.recordType.description,
                                                              predicate: NSPredicate(format: "\(FriendsTable.receiverId.description) == %@", idNotNull),
                                                              options: [.firesOnRecordCreation,
                                                                        .firesOnRecordDeletion,
                                                                        .firesOnRecordUpdate])
                    
                    // 2. Creating a Subscription which will be sent to iCloud as a wrapper
                    let notification = CKSubscription.NotificationInfo()
                    notification.shouldSendContentAvailable = true
                    
                    newSubscription.notificationInfo = notification
                    
                    // 3. Create a public database where it is going to be placed at
                    let database = CKRepository.container.publicCloudDatabase
                    
                    // 4. Save the new subscription to iCloud
                    database.save(newSubscription) { subscription, error in
                        if let _ = error {
                            return
                        }
                        
                        if let _ = subscription {
                            UserDefaults.standard.set(true, forKey: "FriendsTableSubscription")
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let _ = CKNotification(fromRemoteNotificationDictionary: userInfo) {
            print("notificado")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: FriendsTable.tableChanged.description), object: nil)
            }
            completionHandler(.newData)
            return
        } else {
            completionHandler(.noData)
            return
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

