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
    private let model: Recipe
    
    init(navigationController: UINavigationController,
         model: Recipe) {
        self.navigationController = navigationController
        self.model = model
    }
}

// MARK: - Assemblying
extension DetailInfoAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let networkManager = NetworkDataFetcher()
        let imageCache = ImageCacheService()
        let imageDownloader = ImageDownloader()
        
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                   imageCache: imageCache)
        
        let dataFetcher = DataFetcherService(dataFetcher: networkManager, imageDownloader: imageDownloaderProxy)
        
        let router = DetailInfoRouter(navigationController: navigationController)
        let interactor = DetailInfoInteractor(dataFetcher: dataFetcher)
        let presenter = DetailInfoPresenter(interactor: interactor,
                                            router: router,
                                            model: model)
        let viewController = DetailInfoViewController(presenter: presenter)
        presenter.delegate = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}

