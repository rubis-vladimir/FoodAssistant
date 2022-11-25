//
//  DetailInfoAssembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля
final class DetailInfoAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension DetailInfoAssembly: Assemblying {
    func assembly() -> UIViewController {
        let router = DetailInfoRouter(navigationController: navigationController)
        let interactor = DetailInfoInteractor()
        let presenter = DetailInfoPresenter(interactor: interactor,
                                  router: router)
        let viewController = DetailInfoViewController(presenter: presenter)
        presenter.delegate = viewController
        interactor.presenter = presenter
    
        return viewController
    }
}

