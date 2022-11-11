//
//  Assembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля
final class Assembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension Assembly: Assemblying {
    func assembly() -> UIViewController {
        
        let networkDF = NetworkDataFetcher()
        let dataFetcher = DataFetcherService(dataFetcher: networkDF)
        
        let router = Router(navigationController: navigationController)
        let interactor = Interactor(dataFetcher: dataFetcher)
        let presenter = Presenter(interactor: interactor,
                                  router: router)
        let viewController = ViewController(presenter: presenter)
        
        presenter.delegate = viewController
        interactor.presenter = presenter
        return viewController
    }
}

