//
//  BasketPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Навигация в модуле Basket
enum BasketTarget {
    /// Предыдущий экран
    case back
    /// Детальная информация рецепта
    case detailInfo(_ recipe: RecipeProtocol)
}

/// #Протокол управления слоем навигации модуля Basket
protocol BasketRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to target: BasketTarget)
}

/// #Протокол управления View-слоем модуля Basket
protocol BasketViewable: AnyObject {
    /// Обновить Collection View
    ///  - Parameters:
    ///   - recipes: рецепты
    ///   - ingredients: ингредиенты
    func updateCV(recipes: [RecipeViewModel],
                  ingredients: [IngredientViewModel])

    /// Показать / скрыть кнопку добавления ингредиентов в холодильник
    ///  - Parameter flag: да/нет
    func showAddButton(_ flag: Bool)
}

/// #Протокол управления бизнес логикой модуля Basket
protocol BasketBusinessLogic: RecipeReceived,
                              RecipeRemovable,
                              ImageBusinessLogic {
    /// Получит рецепты, добавленные в корзину
    ///  - Parameter completion: захватывает массив рецептов
    func fetchRecipeFromBasket(completion: @escaping ([RecipeViewModel]) -> Void)

    /// Получить ингредиенты, из добавленных рецептов
    /// с учетом имеющихся в холодильнике
    ///  - Parameter completion: захватывает массив ингредиентов
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void)

    /// Изменить чек-флаг в шоп-листе
    /// - Parameters:
    ///  - id: идентификатор ингредиента
    ///  - flag: флаг подтверждения
    func changeIsCheck(id: Int, flag: Bool)

    /// Добавить указанные ингредиенты  в холодильник
    func addIngredientsInFridge()
}

// MARK: - Presenter
/// #Слой презентации модуля Basket
final class BasketPresenter {

    weak var view: BasketViewable?
    private let interactor: BasketBusinessLogic
    private let router: BasketRouting

    /// Вью-модели рецептов
    private var recipes: [RecipeViewModel] = [] {
        didSet {
            updateShopList()
        }
    }
    /// Вью-модели ингредиентов
    private var ingredients: [IngredientViewModel] = []

    init(interactor: BasketBusinessLogic,
         router: BasketRouting) {
        self.interactor = interactor
        self.router = router
    }

    /// Стартовая функция для подгрузки рецептов
    func getStartData() {
        interactor.fetchRecipeFromBasket { [weak self] recipes in
            self?.recipes = recipes
        }
    }

    /// Обновляет Шоп-лист
    private func updateShopList() {
        interactor.fetchIngredients { [weak self] ingredients in
            guard let self = self else { return }
            self.view?.updateCV(recipes: self.recipes,
                                ingredients: ingredients)
        }
    }
}

// MARK: - BasketPresentation
extension BasketPresenter: BasketPresentation {

    func didTapAddFridgeButton() {
        interactor.addIngredientsInFridge()
        updateShopList()
    }

    func checkFlag(id: Int) -> Bool {
        guard let ingredient = ingredients.first(where: {$0.id == id}) else { return false }
        return ingredient.isCheck
    }

    // BackTapable
    func didTapBackButton() {
        router.route(to: .back)
    }

    // RecipeRemovable
    func didTapDeleteButton(id: Int) {
        guard let index = recipes.firstIndex(where: {$0.id == id}) else { return }
        recipes.remove(at: index)
        interactor.removeRecipe(id: id)
        updateShopList()
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
                /// Пока не обрабатывается
                print(error.localizedDescription)
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
