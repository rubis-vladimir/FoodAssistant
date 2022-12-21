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
}

/// #Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновляет `CollectionView`
    /// - Parameter array: массив словарей моделей
    func updateCV(with: [RecipeModelsDictionary])
    
    /// Перезагружает секцию коллекции
    /// - Parameter section: номер секции
    func reloadSection(_ section: Int)
    
    /// Показывает ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля RecipeList
protocol RecipeListBusinessLogic: RecipeReceived,
                                  ImageBusinessLogic {
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
    
    func checkFavoriteRecipe(completion: @escaping ([RecipeViewModel]) -> Void)
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
            update()
        }
    }
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
    deinit {
        print("DEINIT \(self)")
    }
    
    /// Загрузка данных при начальной загрузке приложения
    func getStartData() {
        let filterParameters = RecipeFilterParameters(cuisine: nil, diet: nil, type: "main course", intolerances: [], includeIngredients: [], excludeIngredients: [], maxCalories: nil, sort: nil)
        
        interactor.fetchRecipe(with: filterParameters, number: 4, query: nil) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):

                self?.viewModelsDictionary[.main] = recipeCellModels
                self?.viewModelsDictionary[.recommended] = recipeCellModels.reversed()
            case .failure(_):
                break
            }
        }
    }
    
    private func update() {
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
    func checkFavoriteRecipe() {
    }
    
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                self?.view?.showError()
            }
        }
    }
    
    func didTapFavoriteButton(_ isFavorite: Bool,
                              id: Int) {
        if isFavorite {
            interactor.saveRecipe(id: id,
                                  for: .isFavorite)
        } else {
            interactor.removeRecipe(id: id)
        }
    }
    
    func didTapAddInBasketButton(id: Int) {
        interactor.saveRecipe(id: id,
                              for: .inBasket)
    }
    
    
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] model in
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
