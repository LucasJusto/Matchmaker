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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            }
            else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        //TODO: Uncomment this line to flush existing subscriptions
        flushContainerSubscriptions() {
            CKRepository.getUserId { id in
                if let idNotNull = id {
                    // 1. Create a Query Subscription used on iCloud to filter what shoud be triggered when record type changes
                    let silentSubscription = CKQuerySubscription(recordType: FriendsTable.recordType.description,
                                                              predicate: NSPredicate(format: "\(FriendsTable.receiverId.description) == %@", idNotNull),
                                                              options: [.firesOnRecordCreation,
                                                                        .firesOnRecordDeletion,
                                                                        .firesOnRecordUpdate])
                    
                    // 2. Creating a Subscription which will be sent to iCloud as a wrapper
                    let notification = CKSubscription.NotificationInfo()
                    notification.shouldSendContentAvailable = true
                    silentSubscription.notificationInfo = notification

                    let newFriendReqSubscription = CKQuerySubscription(recordType: FriendsTable.recordType.description,
                                                                           predicate: NSPredicate(format: "\(FriendsTable.receiverId.description) == %@", idNotNull),
                                                                           options: [.firesOnRecordCreation])
                    
                    let friendReqNotification = CKSubscription.NotificationInfo()
                    friendReqNotification.alertBody = NSLocalizedString("friendRequestAlert", comment: "This is the translation for 'friendRequestAlert' at the Friend Profile (OtherPrifile) section of Localizable.strings")
                    friendReqNotification.soundName = "default"
                    newFriendReqSubscription.notificationInfo = friendReqNotification
                    
                    // 3. Create a public database where it is going to be placed at
                    let database = CKRepository.container.publicCloudDatabase
                    
                    let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [silentSubscription, newFriendReqSubscription], subscriptionIDsToDelete: nil)
                    
                    // 4. Save the new subscription to iCloud
                    operation.modifySubscriptionsCompletionBlock = { subscriptions, _ , error in
                        if let _ = error {
                            return
                        }
                    }
                    
                    database.add(operation)
                }
            }
        }
        
        return true
    }
    
    /**
     Flushes all current subscriptions active by the user. 
     */
    func flushContainerSubscriptions (completion: @escaping () -> Void){
        let operation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()
        operation.fetchSubscriptionCompletionBlock = { a, b in
            //print(a, b)
            let operation2 = CKModifySubscriptionsOperation(subscriptionsToSave: nil, subscriptionIDsToDelete: a?.keys.map({ $0 }))
            operation2.modifySubscriptionsCompletionBlock = { _ , deleted, error in
                //print("deleted: \(deleted)")
                //print("error: \(error)")
                completion()
            }
            CKRepository.container.publicCloudDatabase.add(operation2)
        }
        
        CKRepository.container.publicCloudDatabase.add(operation)
    }
    
    /**
     This function handles the silent notifications for the user. The silent notifications are used for friends update inside the app. 
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let _ = CKNotification(fromRemoteNotificationDictionary: userInfo) {
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

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /**
     This functions handles the push notifications received by the user.
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}
