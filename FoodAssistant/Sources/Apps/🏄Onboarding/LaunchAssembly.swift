//
//  LaunchAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля Launch
final class LaunchAssembly {
    
//    private let navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
}

// MARK: - Assemblying
extension LaunchAssembly: Assemblying {
    func assembly() -> UIViewController {
        let router = LaunchRouter()
        let presenter = LaunchPresenter(router: router)
        let viewController = LaunchPageViewController(presenter: presenter)
        presenter.view = viewController
        router.view = viewController
    
        return viewController
    }
}

