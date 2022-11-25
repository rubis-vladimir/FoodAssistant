//
//  DetailInfoInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля
protocol DetailInfoBusinessLogic {
    
}

/// Слой бизнес логике модуля
final class DetailInfoInteractor {
    weak var presenter: DetailInfoBusinessLogicDelegate?
    
    /// Тут настройка Сервисов
}

// MARK: - BusinessLogic
extension DetailInfoInteractor: DetailInfoBusinessLogic {
    
}
