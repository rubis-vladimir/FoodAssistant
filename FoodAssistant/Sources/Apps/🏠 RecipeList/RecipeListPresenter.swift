//
//  RecipeListPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол управления слоем навигации модуля RecipeList
protocol RecipeListRouting {
    /// Переход к экрану детальной информации
    ///  - Parameter model: модель рецепта
    func routeToDetail(model: RecipeProtocol)
    
    func routeToFilter(_ flag: Bool,
                       search: UISearchController,
                       searchDelegate: SeachRecipesRequested)
}

/// #Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновить `CollectionView`
    /// - Parameter array: массив словарей моделей
    func updateCV(with: [RecipeModelsDictionary])
    
    /// Получить текст из поиска
    func getSearchText() -> String?
    
    /// Обновить элементы коллекции
    /// - Parameter indexPaths: массив `IndexPath`
    func updateItems(indexPaths: [IndexPath])
    
    /// Показывает ошибку
    func showError(_ error: Error)
}

/// #Протокол управления бизнес логикой модуля RecipeList
protocol RecipeListBusinessLogic: RecipeReceived,
                                  ImageBusinessLogic,
                                  RecipeRemovable {
    /// Получить рецепт из сети по параметрам
    ///  - Parameters:
    ///   - parameters: установленные параметры
    ///   - number: количество рецептов
    ///   - query: поиск по названию
    ///   - completion: захватывает вью модель рецепта / ошибку
    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void)
    
    /// Получить рекомендованные рецепты
    ///  - Parameters:
    ///   - number: количество рецептов
    ///   - query: поиск по названию
    ///   - completion: захватывает вью модель рецепта / ошибку
    func fetchRecommended(number: Int,
                          completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void)
    
    /// Сохранить рецепт
    /// - Parameters:
    ///   - id: идентификатор рецепта
    ///   - target: цель сохранения
    func saveRecipe(id: Int,
                    for target: TargetOfSave)

    /// Обновляет информацию об избранных рецептах
    func updateFavoriteId()
    
    /// Проверяет находится ли рецепт в избранных
    /// - Parameter id: идентификатор рецепта
    func checkFavorite(id: Int) -> Bool
}

/// #Варианты сборок коллекции модуля RecipeList
enum RLBuildType {
    /// Основная при загрузке
    case main
    /// При поиске рецептов
    case search
}

typealias RecipeModelsDictionary = [RLSectionType: [RecipeViewModel]]

// MARK: - Presenter
/// #Слой презентации модуля RecipeList
final class RecipeListPresenter {
    
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    weak var view: RecipeListViewable?
    
    /// Флаг варианта загрузки данных коллекции
    private var buildType: RLBuildType = .main
    
    private(set) var viewModelsDictionary: RecipeModelsDictionary = [:] {
        didSet {
            updateCV()
        }
    }
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
        
        getStartData()
    }
    
    /// Загрузка данных при начальной загрузке приложения
    func getStartData() {
        let filterParameters = RecipeFilterParameters()
        
//        interactor.fetchRecommended(number: 5) { [weak self] result in
//            switch result {
//            case .success(let recipeModels):
//                self?.viewModelsDictionary[.recommended] = recipeModels
//            case .failure(let error):
//                self?.view?.showError(error)
//            }
//        }
//
//        fetchRecipe(with: filterParameters,
//                    number: 4,
//                    query: nil,
//                    type: .main)
    }
    
    /// Получает рецепты
    ///  - Parameters:
    ///   - parameters: параметры фильтра
    ///   - number: количество рецептов
    ///   - query: название рецепта
    ///   - type: тип секции
    private func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     type: RLSectionType) {
        interactor.fetchRecipe(with: parameters,
                               number: number,
                               query: query) { [weak self] result in
            switch result {
            case .success(let recipeModels):
                self?.viewModelsDictionary[type] = recipeModels
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
    
    /// Обновляет `CollectionView` в зависимости от типа сборки
    private func updateCV() {
        switch buildType {
        case .main:
            let recomendedDictionary = viewModelsDictionary.filter { $0.key == .recommended }
            let mainDictionary = viewModelsDictionary.filter { $0.key == .main }
            
            guard !recomendedDictionary.isEmpty,
                  !mainDictionary.isEmpty else { return }
            view?.updateCV(with: [recomendedDictionary, mainDictionary])
            
        case .search:
            let mainDictionary = viewModelsDictionary.filter { $0.key == .main }
            
            guard !mainDictionary.isEmpty else { return }
            view?.updateCV(with: [mainDictionary])
        }
    }
}

// MARK: - RecipeListPresentation
extension RecipeListPresenter: RecipeListPresentation {
    func didTapFilterButton(_ flag: Bool, search: UISearchController) {
        router.routeToFilter(flag,
                             search: search,
                             searchDelegate: self)
    }
    
    func updateNewData() {
        interactor.updateFavoriteId()
    }
    
    func checkFavorite(id: Int) -> Bool {
        interactor.checkFavorite(id: id)
    }
    
    // ImagePresentation
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
     
    // FavoriteChangable
    func didTapFavoriteButton(_ isFavorite: Bool,
                              id: Int) {
        if isFavorite {
            interactor.saveRecipe(id: id,
                                  for: .isFavorite)
        } else {
            interactor.removeRecipe(id: id)
        }
    }
    
    // InBasketTapable
    func didTapAddInBasketButton(id: Int) {
        interactor.saveRecipe(id: id,
                              for: .inBasket)
    }
    
    // CellSelectable
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] model in
            self?.router.routeToDetail(model: model)
        }
    }
    
    // LayoutChangable
    func didTapChangeLayoutButton(section: Int) {
        
        guard let count = viewModelsDictionary[.main]?.count else { return }
        /// Вызываем уведомление изменения layout
        NotificationCenter.default
            .post(name: NSNotification.Name("changeLayoutType"),
                  object: nil)
        
        guard count > 0 else { return }
        let indexPaths = (0...count-1).map { IndexPath(item: $0, section: section) }
        view?.updateItems(indexPaths: indexPaths)
    }
}

// MARK: - SeachRecipesRequested
extension RecipeListPresenter: SeachRecipesRequested {
    func search(with parameters: RecipeFilterParameters) {
        let text = view?.getSearchText()
        buildType = .search
        
        print(parameters)
        fetchRecipe(with: parameters,
                    number: 6,
                    query: nil,
                    type: .main)
    }
}
