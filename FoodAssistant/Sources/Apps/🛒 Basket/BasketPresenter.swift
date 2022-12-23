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
    
    /// Показывает / скрывает кнопку добавления ингредиентов в холодильник
    ///  - Parameter flag: да/нет
    func showAddButton(_ flag: Bool)
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
    
    /// Изменяет чек-флаг в шоп-листе
    /// - Parameters:
    ///  - id: идентификатор ингредиента
    ///  - flag: флаг подтверждения
    func changeIsCheck(id: Int, flag: Bool)
    
    /// Приобретенные ингредиенты добавить в холодильник
    func addIngredientsInFridge()
}

// MARK: - Presenter
/// #Слой презентации модуля Basket
final class BasketPresenter {
    
    private let interactor: BasketBusinessLogic
    private let router: BasketRouting
    
    weak var view: BasketViewable?
    
    private(set) var models: [RecipeProtocol] = [] {
        didSet {
            updateShopList()
        }
    }
    
    private(set) var ingredients: [IngredientViewModel] = []
    
    init(interactor: BasketBusinessLogic,
         router: BasketRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    private func updateShopList() {
        guard !models.isEmpty else {
            view?.updateCV(recipes: [], ingredients: [])
            return
        }
        
        interactor.fetchIngredients { [weak self] ingredients in
            guard let self = self else { return }
            self.view?.updateCV(recipes: self.models,
                                ingredients: ingredients)
        }
    }
}

// MARK: - BasketPresentation
extension BasketPresenter: BasketPresentation {
    
    func fetchAddedRecipe() {
        interactor.fetchRecipeInBasket { [weak self] recipes in
            self?.models = recipes
        }
    }
    
    func checkFlag(id: Int) -> Bool {
        guard let ingredient = ingredients.first(where: {$0.id == id} ) else { return false }
        return ingredient.isCheck
    }
    
    func didTapAddFridgeButton() {
        interactor.addIngredientsInFridge()
        updateShopList()
    }
    
    func route(to: BasketTarget) {
        router.route(to: to)
    }
    
    // RecipeRemovable
    func didTapDeleteButton(id: Int) {
        guard let index = models.firstIndex(where: {$0.id == id} ) else { return }
        models.remove(at: index)
        interactor.deleteFromBasket(id: id)
    }
    
    // SelectedCellDelegate
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] recipe in
            self?.router.route(to: .detailInfo(recipe))
        }
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
                print(error)
            }
        }
    }
    
    // CheckChangable
    func didTapCheckButton(id: Int, flag: Bool) {
        interactor.changeIsCheck(id: id, flag: flag)
    }
}

// MARK: - BasketBusinessLogicDelegate
extension BasketPresenter: BasketBusinessLogicDelegate {
    func handOver(ingredients: [IngredientViewModel]) {
        self.ingredients = ingredients
        
        if ingredients.first(where: { $0.isCheck == true }) != nil {
            view?.showAddButton(true)
        } else {
            view?.showAddButton(false)
        }
    }
}
