//
//  UserProfileAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля UserProfile
final class UserProfileAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension UserProfileAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let imageDownloader = ImageDownloader()
        let imageCacheService = ImageCacheService()
        let fileManager = FileManagerService.shared
        let imageDownloaderProxy = ImageDownloaderProxy(imageDownloader: imageDownloader,
                                                        imageCache: fileManager)
        
        let storage = StorageManager.shared
        
        let router = UserProfileRouter(navigationController: navigationController)
        let interactor = UserProfileInteractor(imageDownloader: imageDownloaderProxy,
                                               storage: storage)
        let presenter = UserProfilePresenter(interactor: interactor,
                                  router: router)
        let viewController = UserProfileViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

