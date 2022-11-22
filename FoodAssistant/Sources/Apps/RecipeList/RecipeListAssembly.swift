//
//  Assembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля RecipeList
final class RecipeListAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension RecipeListAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let networkDataFetcher = NetworkDataFetcher()
        let dataFetcherService = DataFetcherService(dataFetcher: networkDataFetcher)
        let imageDownloader = ImageDownloader()
        let imageDownloadService = ImageDownloadService(imageDownloader: imageDownloader)
        
        let router = RecipeListRouter(navigationController: navigationController)
        let interactor = RecipeListInteractor(dataFetcher: dataFetcherService,
                                              imageDownloadManager: imageDownloadService)
        let presenter = RecipeListPresenter(interactor: interactor,
                                  router: router)
        let viewController = RecipeListViewController(presenter: presenter)
        
        presenter.delegate = viewController
        interactor.presenter = presenter
        presenter.getStartData()
        
        return viewController
    }
}

