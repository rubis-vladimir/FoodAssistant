//
//  BasketPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Навигация в модуле Basket
enum BasketTarget {
    /// Возврат на предыдущий экран
    case back
    /// Детальная информация рецепта
    case detailInfo(_ recipe: RecipeProtocol)
}

/// #Протокол управления слоем навигации модуля Basket
protocol BasketRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: BasketTarget)
}

/// #Протокол управления View-слоем модуля Basket
protocol BasketViewable: AnyObject {
    /// Обновление Collection View
    ///  - Parameters:
    ///   - recipes: рецепты
    ///   - ingredients: ингредиенты
    func updateCV(recipes: [RecipeProtocol],
                  ingredients: [IngredientViewModel])
    /// Показать ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля Basket
protocol BasketBusinessLogic: RecipeReceived,
                              ImageBusinessLogic{
    /// Получает рецепты, добавленные в корзину
    ///  - Parameter completion: захватывает массив рецептов
    func fetchRecipeInBasket(completion: @escaping ([RecipeProtocol]) -> Void)
    
    /// Получает ингредиенты, из добавленных рецептов
    /// с учетом имеющихся в холодильнике
    ///  - Parameter completion: захватывает массив ингредиентов
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void)
    
    /// Удаляет рецепт из корзины
    ///  - Parameter id: идентификатор рецепта
    func deleteFromBasket(id: Int)
}

// MARK: - Presenter
/// #Слой презентации модуля Basket
final class BasketPresenter {
    
    private let interactor: BasketBusinessLogic
    private let router: BasketRouting
    
    weak var view: BasketViewable?
    
    var models: [RecipeProtocol] = [] {
        didSet {
            if models.isEmpty {
                view?.updateCV(recipes: [], ingredients: [])
            } else {
                interactor.fetchIngredients { [weak self] ingredients in
                    guard let self = self else { return }
                    self.view?.updateCV(recipes: self.models,
                                        ingredients: ingredients)
                }
            }
        }
    }
    
    init(interactor: BasketBusinessLogic,
         router: BasketRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - BasketPresentation
extension BasketPresenter: BasketPresentation {
    func route(to: BasketTarget) {
        router.route(to: to)
    }
    
    func fetchAddedRecipe() {
        interactor.fetchRecipeInBasket { [weak self] recipes in
            self?.models = recipes
        }
    }
    
    func didTapDeleteButton(id: Int) {
        interactor.deleteFromBasket(id: id)
        
        guard let index = models.firstIndex(where: {$0.id == id} ) else { return }
        models.remove(at: index)
    }
    
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] recipe in
            self?.router.route(to: .detailInfo(recipe))
        }
    }
    
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - BasketBusinessLogicDelegate
extension BasketPresenter: BasketBusinessLogicDelegate {
    func handOver(ingredients: [IngredientProtocol]) {
        
    }
}
