//
//  UserProfileAssembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля UserProfile
final class UserProfileAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension UserProfileAssembly: Assemblying {
    func assembly() -> UIViewController {
        let router = UserProfileRouter(navigationController: navigationController)
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter(interactor: interactor,
                                  router: router)
        let viewController = UserProfileViewController(presenter: presenter)
        presenter.delegate = viewController
        interactor.presenter = presenter
    
        return viewController
    }
}

