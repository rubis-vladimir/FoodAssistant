//
//  DetailInfoPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол делегата прокрутки экрана
protocol ScrollDelegate: AnyObject {
    /// Отслеживает перемещение scrollView
    /// - Parameter offset: перемещение Y
    func scrollViewDidScroll(to offset: CGFloat)
}

/// #Протокол управления бизнес логикой модуля DetailInfo
protocol DetailInfoBusinessLogic {
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImageRecipe(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - size: размер изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImageIngredients(_ imageName: String,
                               size: ImageSize,
                               completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Слой презентации модуля DetailInfo
final class DetailInfoPresenter {
    private let interactor: DetailInfoBusinessLogic
    private let router: DetailInfoRouting
    
    private(set) var model: RecipeProtocol
    
    init(interactor: DetailInfoBusinessLogic,
         router: DetailInfoRouting,
         model: RecipeProtocol) {
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
