//
//  DetailInfoPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол передачи UI-ивентов слою презентации
protocol DetailInfoPresentation: AnyObject {
    var model: Recipe { get }
    
    func fetchImage(with imageName: String, completion: @escaping (Data) -> Void)
    func fetchImage(with imageName: String, size: ImageSize, completion: @escaping (Data) -> Void)
    
    func didTapBackButton()
}

/// #Слой презентации модуля
final class DetailInfoPresenter {
    private let interactor: DetailInfoBusinessLogic
    private let router: DetailInfoRouting
    
    private(set) var model: Recipe
    
    init(interactor: DetailInfoBusinessLogic,
         router: DetailInfoRouting,
         model: Recipe) {
        self.interactor = interactor
        self.router = router
        self.model = model
    }
}

// MARK: - Presentation
extension DetailInfoPresenter: DetailInfoPresentation {
    func fetchImage(with imageName: String, completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName) { result in
            switch result {
                
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
    
    func fetchImage(with imageName: String, size: ImageSize, completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, size: size) { result in
            switch result {
                
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
    
    func didTapBackButton() {
        router.routeToBack()
    }
}
