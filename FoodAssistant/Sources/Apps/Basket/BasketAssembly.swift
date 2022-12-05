//
//  Assembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля Basket
final class BasketAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension BasketAssembly: Assemblying {
    func assembly() -> UIViewController {
        let router = BasketRouter(navigationController: navigationController)
        let interactor = BasketInteractor()
        let presenter = BasketPresenter(interactor: interactor,
                                  router: router)
        let viewController = BasketViewController(presenter: presenter)
        presenter.delegate = viewController
        interactor.presenter = presenter
    
        return viewController
    }
}

