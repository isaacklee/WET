//
//  AppDelegate.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UIColor(red: 0.57, green: 0.725, blue: 0.858, alpha: 1)
        UITabBar.appearance().barTintColor = UIColor(red: 0.929, green: 0.933, blue: 0.9371, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 0.57, green: 0.725, blue: 0.858, alpha: 1)
        FirebaseApp.configure()
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

