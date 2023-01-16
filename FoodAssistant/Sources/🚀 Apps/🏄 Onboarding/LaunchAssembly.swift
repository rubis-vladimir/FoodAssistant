//
//  LaunchAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля Launch
final class LaunchAssembly { }

// MARK: - Assemblying
extension LaunchAssembly: Assemblying {
    
    func assembly() -> UIViewController {
        let router = LaunchRouter()
        let presenter = LaunchPresenter(router: router)
        let viewController = LaunchPageViewController(presenter: presenter)
        
        presenter.view = viewController
    
        return viewController
    }
}
