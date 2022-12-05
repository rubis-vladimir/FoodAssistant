//
//  DetailInfoPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол передачи UI-ивентов слою презентации
protocol DetailInfoPresentation: AnyObject {
    /// Модель рецепта
    var model: Recipe { get }
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchRecipe(with imageName: String,
                     completion: @escaping (Data) -> Void)
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - size: размер изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchIngredients(with imageName: String,
                          size: ImageSize,
                          completion: @escaping (Data) -> Void)
    
    /// Нажата кнопка назад
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
    func fetchRecipe(with imageName: String, completion: @escaping (Data) -> Void) {
        interactor.fetchImageRecipe(imageName) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
    
    func fetchIngredients(with imageName: String, size: ImageSize, completion: @escaping (Data) -> Void) {
        interactor.fetchImageIngredients(imageName, size: size) { result in
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
