//
//  BasketAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля Basket
final class BasketAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension BasketAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let imageDownloader = ImageDownloader.shared
        let imageCacheService = ImageCacheService()
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                        imageCache: imageCacheService)
        
        let storage = StorageManager.shared
        let ingredientManager = IngredientCalculateManager(storage: storage)
        
        let router = BasketRouter(navigationController: navigationController)
        let interactor = BasketInteractor(imageDownloader: imageDownloaderProxy,
                                          storage: storage,
                                          ingredientManager: ingredientManager)
        let presenter = BasketPresenter(interactor: interactor,
                                  router: router)
        let viewController = BasketViewController(presenter: presenter)
        presenter.view = viewController
        interactor.presenter = presenter
    
        return viewController
    }
}

