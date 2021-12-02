//
//  AppDelegate.swift
//  Together
//
//  Created by lcx on 2021/10/28.
//

import UIKit
import CoreData
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        let gradientlayer = CAGradientLayer()
//        gradientlayer.frame = UINavigationBar.appearance().bounds
//        gradientlayer.colors = [UIColor(named: "bgLightPurple")!.cgColor, UIColor.white.cgColor]
//        gradientlayer.locations = [0, 1]
//        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientlayer.endPoint = CGPoint(x: 1.0, y: 0.0)
//        let nvAppearance = UINavigationBarAppearance()
//        nvAppearance.configureWithOpaqueBackground()
//        nvAppearance.backgroundImage = GradientColor.image(fromLayer: gradientlayer)
//        nvAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        nvAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().standardAppearance = nvAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = nvAppearance
        
        do {
            let model = AmplifyModels()
            let APIPlugin = AWSAPIPlugin(modelRegistration: model)
            
            let datastoreConfiguration = DataStoreConfiguration.custom(authModeStrategy: .default)
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: model, configuration: datastoreConfiguration)
            
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: APIPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            Amplify.DataStore.clear() { _ in }
            print("Amplify configured with auth plugin")
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

