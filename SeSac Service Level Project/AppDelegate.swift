//
//  AppDelegate.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/17.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            print("permisson granted: \(granted)")
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        return true
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


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Toekn : ", fcmToken!)
        if let fcmToken = fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: UserDefaults.myKey.fcmToken.rawValue)
        }
    }
}

extension AppDelegate:  UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register to remote: \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
          
          
          guard let aps = userInfo["aps"] as? [String: Any] else {
              print("not good ")
              return
          }
          
          let alertDic = aps["alert"] as? [String: String]
          
          print(alertDic, "alert")
//        print(userInfo, "this?is")

          
          
          
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        let userInfo = response.notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String: Any] else {
            print("not good ")
            return
        }
        
        let alertDic = aps["alert"] as? [String: String]
        print(alertDic, "alert")
        let a = alertDic!["body"]
        
        
        if a == "님이 취미 함께하기를 요청했습니다." {
            NotificationCenter.default.post(name: .requestPush, object: nil)
        }else if a == "님이 취미 함께하기를 수락하셨습니다." {
            NotificationCenter.default.post(name: .acceptPush, object: nil)
        }else if a == "상대방이 약속을 취소하였습니다" {
            NotificationCenter.default.post(name: .cancelPush, object: nil)
        }else {
            NotificationCenter.default.post(name: .chatPush, object: nil)
        }
        completionHandler()
        }
    

}

extension NSNotification.Name {
    static let cancelPush = NSNotification.Name("cancel")
    static let requestPush = NSNotification.Name("request")
    static let acceptPush = NSNotification.Name("accept")
    static let chatPush = NSNotification.Name("chat")
}



//aps : {
//    "mutable-content" : "1",
//    "category" : "1",
//    "alert" : {
//      "title" : "우우오",
//      "body" : "안녕하세요. 스쿠버다이빙 좋아하시는 것 같아 연락했어요."
//    },

//[AnyHashable("gcm.message_id"): 1645507328721611,
// AnyHashable("Nick"): 박은,
// AnyHashable("google.c.sender.id"): 355153590205,
// AnyHashable("google.c.a.e"): 1,
// AnyHashable("google.c.fid"): cgTpk-9sh01WvKY0s0SjqA,
// AnyHashable("aps"): {
//    alert =     {
//        body = "\Ub2d8\Uc774 \Ucde8\Ubbf8 \Ud568\Uaed8\Ud558\Uae30\Ub97c \Uc694\Uccad\Ud588\Uc2b5\Ub2c8\Ub2e4.";
//        title = "\Ubc15\Uc740";
//    };
//    "content-available" = 1;
//    "mutable-content" = 1;
//},
// AnyHashable("hobbyRequest"): hobbyRequest]
