//
//  DetailInfoAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля DetailInfo
final class DetailInfoAssembly {
    private let navigationController: UINavigationController
    private let recipe: RecipeProtocol
    
    init(navigationController: UINavigationController,
         recipe: RecipeProtocol) {
        self.navigationController = navigationController
        self.recipe = recipe
    }
}

// MARK: - Assemblying
extension DetailInfoAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let imageCache = ImageCacheService()
        let imageDownloader = ImageDownloader.shared
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                        imageCache: imageCache)
        let storage = StorageManager.shared
        let timerManager = TimerManager.shared
        
        let router = DetailInfoRouter(navigationController: navigationController)
        let interactor = DetailInfoInteractor(imageDownloader: imageDownloaderProxy,
                                              storage: storage,
                                              timerManager: timerManager)
        let presenter = DetailInfoPresenter(interactor: interactor,
                                            router: router,
                                            recipe: recipe)
        let viewController = DetailInfoViewController(presenter: presenter)
        
        presenter.view = viewController
        return viewController
    }
}

