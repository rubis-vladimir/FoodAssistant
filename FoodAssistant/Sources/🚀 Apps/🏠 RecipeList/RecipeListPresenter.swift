//
//  RecipeListPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления слоем навигации модуля RecipeList
protocol RecipeListRouting {
    /// Переход к экрану детальной информации
    ///  - Parameter model: модель рецепта
    func routeToDetail(model: RecipeProtocol)
    
    /// Переход к экрану фильтра и обратно
    ///  - Parameters:
    ///   - flag: флаг перехода
    ///   - search: поисковый контроллер
    ///   - searchDelegate: делегат поиска
    func routeToFilter(_ flag: Bool,
                       searchDelegate: SeachRecipesRequested)
}

/// #Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: ErrorShowable, AnyObject {
    /// Обновить `CollectionView`
    /// - Parameter array: массив словарей моделей
    func updateCV(with: [RecipeModelsDictionary])
    
    /// Получить текст из поиска
    func getSearchText() -> String?
    
    /// Обновить элементы коллекции
    /// - Parameter indexPaths: массив `IndexPath`
    func updateItems(indexPaths: [IndexPath])
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
        var filterParameters = RecipeFilterParameters()
        filterParameters.includeIngredients = ["onion", "chiken"]

        // Загрузка данных для секции Recommended
        interactor.fetchRecommended(number: AppConstants.minRequestAmount) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let recipeModels): // Успех
                self.viewModelsDictionary[.recommended] = recipeModels

            case .failure(let error): // Ошибка
                /// Действие, если ошибка восстанавливаемая
                let action = { self.getStartData() }
                ///
                self.showRecoveryError(from: error,
                                       action: action)
            }
        }

        // Загрузка данных для секции Main
        fetchRecipe(with: filterParameters,
                    number: AppConstants.minRequestAmount,
                    query: nil,
                    type: .main)
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
            guard let self = self else { return }
            
            switch result {
            case .success(let recipeModels): // Успех
                self.viewModelsDictionary[type] = recipeModels
                
            case .failure(let error): // Ошибка
                /// Действие при восстановлении
                let action = {
                    self.fetchRecipe(with: parameters,
                                     number: number,
                                     query: query,
                                     type: .main)
                    
                }
                self.showRecoveryError(from: error,
                                       action: action)
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
    
    /// Конфигурирует и показывает восстанавливаемую ошибку
    /// - Parameters:
    ///  - error: ошибка
    ///  - action: действи при восстановлении
    private func showRecoveryError(from error: DataFetcherError,
                                   action: @escaping () -> ()) {
        var actions: [RecoveryOptions] = [.cancel]
        
        switch error {
        case .invalidResponceCode, .dataLoadingError:
            let tryAgainAction = RecoveryOptions.tryAgain(action: action)
            actions.append(tryAgainAction)
        default: break
        }
        
        view?.show(rError: RecoverableError(error: error,
                                            recoveryOptions: actions))
    }
}

// MARK: - RecipeListPresentation
extension RecipeListPresenter: RecipeListPresentation {
    func didTapFilterButton(_ flag: Bool) {
        router.routeToFilter(flag,
                             searchDelegate: self)
    }
    
    func updateNewData() {
        interactor.updateFavoriteId()
        updateCV()
    }
    
    func checkFavorite(id: Int) -> Bool {
        interactor.checkFavorite(id: id)
    }
    
    // ImagePresentation
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                /// Пока не обрабатывается
                print(error.localizedDescription)
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
        
        fetchRecipe(with: parameters,
                    number: AppConstants.minRequestAmount,
                    query: text,
                    type: .main)
    }
}
