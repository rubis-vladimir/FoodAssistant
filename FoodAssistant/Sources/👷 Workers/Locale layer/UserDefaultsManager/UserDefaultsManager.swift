//
//  UserDefaultsManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import Foundation

protocol UserDefaultsManagement {
    
    func checkReady() -> Bool
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let ud = UserDefaults.standard
    private init() {}
    
}

extension UserDefaultsManager: UserDefaultsManagement {
    func checkReady() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserReady.rawValue)
    }
}
