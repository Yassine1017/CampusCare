//
//  AppDelegate.swift
//  CampusCare_S3_G5
//
//  Created by BP-36-201-18 on 03/12/2025.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    





    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        // 1. Configure Firebase only once (with safety check)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // 2. Setup Navigation Appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .systemBlue
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = navAppearance
        navBar.scrollEdgeAppearance = navAppearance
        navBar.compactAppearance = navAppearance
        navBar.tintColor = .white

        // 3. Handle Authentication
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("Error signing in anonymously: \(error.localizedDescription)")
                }
            }
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
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

