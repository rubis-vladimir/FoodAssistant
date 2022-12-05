//
//  Assembly.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля RecipeList
final class RecipeListAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension RecipeListAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        
        let networkManager = NetworkDataFetcher()
        let translateService = TranslateService(dataFetcher: networkManager)
        
        let imageDownloader = ImageDownloader()
        let imageCacheService = ImageCacheService()
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                        imageCache: imageCacheService)
        
//        let dataFetcherService = DataFetcherService(dataFetcher: networkDataFetcher,
//                                                    imageDownloader: imageDownloaderProxy)
        
        
        let router = RecipeListRouter(navigationController: navigationController)
        let interactor = RecipeListInteractor(dataFetcher: networkManager,
                                              imageDownloader: imageDownloaderProxy,
                                              translateService: translateService)
        let presenter = RecipeListPresenter(interactor: interactor,
                                  router: router)
        let viewController = RecipeListViewController(presenter: presenter)
        
        presenter.delegate = viewController
        interactor.presenter = presenter
        presenter.getStartData()
        
        return viewController
    }
}

