//
//  UserProfileInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic {
    
}

/// Слой бизнес логике модуля UserProfile
final class UserProfileInteractor {
    weak var presenter: UserProfileBusinessLogicDelegate?
    
    /// Тут настройка Сервисов
}

// MARK: - BusinessLogic
extension UserProfileInteractor: UserProfileBusinessLogic {
    
}
