//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol Presentation {
    
}

/// Протокол делегата бизнес логики
protocol BusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля
final class Presenter {
    weak var delegate: Viewable?
    private let interactor: BusinessLogic
    private let router: Routing
    
    init(interactor: BusinessLogic,
         router: Routing) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presentation
extension Presenter: Presentation {
    
}

// MARK: - BusinessLogicDelegate
extension Presenter: BusinessLogicDelegate {
    
}
