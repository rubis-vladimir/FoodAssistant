//
//  RecipeListAssembly.swift
//  FoodAssistant
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
        /// Менеджер для работы с сетью
        let networkManager = NetworkDataFetcher.shared
        /// Сервис перевода текста
        let translateService = TranslateService(dataFetcher: networkManager)
        
        /// Сервис загрузки изображений
        let imageDownloader = ImageDownloader.shared
        /// Сервис кеширования изображений
        let imageCacheService = ImageCacheService()
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                        imageCache: imageCacheService)
        /// Менеджер работы с БД
        let storage = StorageManager.shared
        
        /// Модуль VIPER
        let router = RecipeListRouter(navigationController: navigationController)
        let interactor = RecipeListInteractor(dataFetcher: networkManager,
                                              imageDownloader: imageDownloaderProxy,
                                              translateService: translateService,
                                              storage: storage)
        let presenter = RecipeListPresenter(interactor: interactor,
                                            router: router)
        let viewController = RecipeListViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.getStartData()
        
        return viewController
    }
}

