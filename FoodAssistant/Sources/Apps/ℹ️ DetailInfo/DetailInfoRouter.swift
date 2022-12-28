//
//  DetailInfoRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля DetailInfo
final class DetailInfoRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - DetailInfoRouting
extension DetailInfoRouter: DetailInfoRouting {
    func routeToBack() {
//        navigationController.navigationBar.isTranslucent = false
        navigationController.createCustomTransition(with: .fade)
        navigationController.popViewController(animated: true)
    }
}
