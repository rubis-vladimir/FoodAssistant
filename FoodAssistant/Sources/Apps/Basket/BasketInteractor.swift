//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля Basket
protocol BasketBusinessLogic {
    
}

/// Слой бизнес логике модуля Basket
final class BasketInteractor {
    weak var presenter: BasketBusinessLogicDelegate?
    
    /// Тут настройка Сервисов
}

// MARK: - BasketBusinessLogic
extension BasketInteractor: BasketBusinessLogic {
    
}
