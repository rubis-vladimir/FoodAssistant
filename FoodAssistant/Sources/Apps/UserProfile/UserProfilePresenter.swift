//
//  UserProfilePresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol UserProfilePresentation: AnyObject {
    func showTag()
    
    
}

/// Протокол делегата бизнес логики модуля UserProfile
protocol UserProfileBusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля UserProfile
final class UserProfilePresenter {
    weak var delegate: UserProfileViewable?
    private let interactor: UserProfileBusinessLogic
    private let router: UserProfileRouting
    
    init(interactor: UserProfileBusinessLogic,
         router: UserProfileRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presentation
extension UserProfilePresenter: UserProfilePresentation {
    
    func showTag() {
        delegate?.showTag()
    }
}

// MARK: - BusinessLogicDelegate
extension UserProfilePresenter: UserProfileBusinessLogicDelegate {
    
}
