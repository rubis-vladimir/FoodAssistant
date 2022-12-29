//
//  BasketRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля Basket
final class BasketRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - BasketBasketRouting
extension BasketRouter: BasketRouting {
    func route(to: BasketTarget) {
        switch to {
        case .back:
            navigationController.createCustomTransition(with: .fade)
            navigationController.navigationBar.isHidden = true
            navigationController.popViewController(animated: false)
            
        case .detailInfo(let model):
            let vc = DetailInfoAssembly(navigationController: navigationController,
                                        recipe: model).assembly()
            vc.hidesBottomBarWhenPushed = true
            navigationController.navigationBar.isTranslucent = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
