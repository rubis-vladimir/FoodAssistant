//
//  AppDelegate.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let userDefaults = UserDefaultsManager.shared

        ApplicationCoordinator(window: window,
                               userDefaults: userDefaults).start()
        return true
    }
}
