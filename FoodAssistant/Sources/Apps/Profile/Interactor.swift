//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля
protocol BusinessLogic {
    
}

/// Слой бизнес логике модуля
final class Interactor {
    weak var presenter: BusinessLogicDelegate?
    
    /// Тут настройка Сервисов
}

// MARK: - BusinessLogic
extension Interactor: BusinessLogic {
    
}
