//
//  LaunchPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation


/// #Протокол управления слоем навигации модуля Launch
protocol LaunchRouting {
    /// Переход к основному экрану приложения
    func routeToMainScreen()
}

// MARK: - Presenter
/// #Слой презентации модуля Launch
final class LaunchPresenter {
    weak var view: LaunchViewable?
    private let router: LaunchRouting
    
    init(router: LaunchRouting) {
        self.router = router
    }
}

// MARK: - LaunchPresentation
extension LaunchPresenter: LaunchPresentation {
    func didTapReadyButton() {
//        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isUserReady.rawValue)
        
        router.routeToMainScreen()
    }
}
