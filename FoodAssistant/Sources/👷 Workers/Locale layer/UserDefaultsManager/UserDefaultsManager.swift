//
//  UserDefaultsManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import Foundation

/// #Протокол проверки готовности пользователя
protocol UserDefaultsVerifable {
    func checkReady() -> Bool
}

/// #Сервис работы с UserDefaults
final class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
}

// MARK: - UserDefaultsVerifable
extension UserDefaultsManager: UserDefaultsVerifable {
    func checkReady() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserReady.rawValue)
    }
}
