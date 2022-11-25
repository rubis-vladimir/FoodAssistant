//
//  DetailInfoPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol DetailInfoPresentation {
    
}

/// Протокол делегата бизнес логики
protocol DetailInfoBusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля
final class DetailInfoPresenter {
    weak var delegate: DetailInfoViewable?
    private let interactor: DetailInfoBusinessLogic
    private let router: DetailInfoRouting
    
    init(interactor: DetailInfoBusinessLogic,
         router: DetailInfoRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presentation
extension DetailInfoPresenter: DetailInfoPresentation {
    
}

// MARK: - BusinessLogicDelegate
extension DetailInfoPresenter: DetailInfoBusinessLogicDelegate {
    
}
