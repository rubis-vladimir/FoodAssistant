//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления слоем навигации модуля RecipeList
protocol RecipeListRouting {
    /// Переход к экрану детальной информации
    ///  - Parameter model: модель рецепта
    func routeToDetail(model: RecipeProtocol)
}

/// #Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновляет UI
    /// - Parameter type: тип сборки
    func updateUI(with type: RLBuildType)
    
    /// Перезагружает секцию коллекции
    /// - Parameter section: номер секции
    func reloadSection(_ section: Int)
    
    /// Показывает ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля RecipeList
protocol RecipeListBusinessLogic {
    /// Получить модель по идентификатору
    ///  - Parameters:
    ///   - id: идентификатор
    ///   - completion: захватывает модель рецепта
    func getModel(id: Int,
                  completion: @escaping (RecipeProtocol) -> Void)
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    /// Получить рецепт из сети
    ///  - Parameters:
    ///   - parameters: установленные параметры
    ///   - number: количество рецептов
    ///   - query: поиск по названию
    ///   - completion: захватывает вью модель рецепта / ошибку
    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void)
    
    /// Удалить рецепт
    /// - Parameter id: идентификатор рецепта
    func removeRecipe(id: Int)
    
    /// Сохранить рецепт
    /// - Parameters:
    ///   - id: идентификатор рецепта
    ///   - target: цель сохранения
    func saveRecipe(id: Int,
                    for target: TargetOfSave)
}


// MARK: - Presenter
/// #Слой презентации модуля RecipeList
final class RecipeListPresenter {
    
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    weak var view: RecipeListViewable?
    
    private(set) var viewModels: [RLModelType: [RecipeViewModel]] = [:] {
        didSet {
            if isStart {
                guard let recommended = viewModels[.recommended],
                      let main = viewModels[.main] else { return }
                
                view?.updateUI(with: .main(first: recommended,
                                               second: main))
            } else {
                guard let main = viewModels[.main] else { return }
                view?.updateUI(with: .search(models: main))
            }
        }
    }
    /// Флаг варианта загрузки данных коллекции
    private var isStart: Bool = false
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    /// Загрузка данных при начальной загрузке приложения
    func getStartData() {
        let filterParameters = RecipeFilterParameters(cuisine: nil, diet: nil, type: "salad", intolerances: [], includeIngredients: ["meat"], excludeIngredients: [], maxCalories: nil, sort: nil)
        
        interactor.fetchRecipe(with: filterParameters, number: 3, query: nil) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):
                
                self?.viewModels[.main] = recipeCellModels
                
            case .failure(_):
                break
            }
        }
        
//
//         Доп запрос
//                interactor.fetchRecipe(with: filterParameters, number: 3, query: nil) { [weak self] result in
//                    switch result {
//                    case .success(let recipeCellModels):
//                        self?.viewModels[.recommended] = recipeCellModels
//                    case .failure(_):
//                        break
//                    }
//                }
        
    }
}

// MARK: - Presentation
extension RecipeListPresenter: RecipeListPresentation {
    
    func fetchImage(with imageName: String,
               completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                self?.view?.showError()
            }
        }
    }
}


extension RecipeListPresenter {

    func didTapFavoriteButton(_ isFavorite: Bool, id: Int) {
        if isFavorite {
            interactor.saveRecipe(id: id, for: .favorite)
        } else {
            interactor.removeRecipe(id: id)
        }
    }
    
    func didTapAddIngredientsButton(id: Int) {
        
        interactor.saveRecipe(id: id, for: .basket)
    }
    
    func didSelectItem(id: Int) {
        interactor.getModel(id: id) { [weak self] model in
            self?.router.routeToDetail(model: model)
        }
    }
    
    func didTapChangeLayoutButton(section: Int) {
        /// Вызываем уведомление изменения layout
        NotificationCenter.default
                    .post(name: NSNotification.Name("changeLayoutType"),
                     object: nil)
        view?.reloadSection(section)
    }
}
