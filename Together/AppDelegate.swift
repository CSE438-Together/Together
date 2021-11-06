//
//  AppDelegate.swift
//  Together
//
//  Created by lcx on 2021/10/28.
//

import UIKit
import Amplify
import AWSAPIPlugin
import AWSDataStorePlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        do {
            let model = AmplifyModels()
            let APIPlugin = AWSAPIPlugin(modelRegistration: model)
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: model)
            try Amplify.add(plugin: APIPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

