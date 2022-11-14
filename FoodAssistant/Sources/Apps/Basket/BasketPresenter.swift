//
//  BasketPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol BasketPresentation {
    
}

/// Протокол делегата бизнес логики
protocol BasketBusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля Basket
final class BasketPresenter {
    weak var delegate: BasketViewable?
    private let interactor: BasketBusinessLogic
    private let router: BasketRouting
    
    init(interactor: BasketBusinessLogic,
         router: BasketRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - BasketPresentation
extension BasketPresenter: BasketPresentation {
    
}

// MARK: - BasketBusinessLogicDelegate
extension BasketPresenter: BasketBusinessLogicDelegate {
    
}
