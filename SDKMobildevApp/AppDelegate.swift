//
//  AppDelegate.swift
//  SDKMobildevApp
//
//  Created by Burak Turhan on 13.08.2025.
//

import UIKit
import mobildevSDK 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let cfg = mobildevSDKConfig(
                   apiKey: "your-key",
                   endpoint: URL(string: "https://api.example.com/track")!,
                   flushAtLaunch: true,
                   maxRetryCount: 3
               )

               mobildevSDKClient.shared.initialize(config: cfg)
               mobildevSDKClient.shared.trackScreen("Home")
               mobildevSDKClient.shared.trackClick("BuyButton")
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

