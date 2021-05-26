//
//  AppDelegate.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/20/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // load database
        let _ = Database.shared
        
        NotificationCenter.default.addObserver(self, selector: #selector(showList), name: .loggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLogin), name: .loggedOut, object: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaults.standard.bool(forKey: hasLoggedInKey) {
            showList()
        } else {
            showLogin()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @objc private func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        window?.rootViewController =  storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
    
    @objc private func showList() {
        let storyboard = UIStoryboard(name: "CarList", bundle: .main)
        window?.rootViewController =  storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
}

