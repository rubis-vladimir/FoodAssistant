//
//  BasketInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол взаимодействия со слоем презентации модуля Basket
protocol BasketBusinessLogicDelegate: AnyObject {

    /// Передать ингредиенты
    ///  - Parameter ingredients: массив ингредиентов
    func handOver(ingredients: [IngredientViewModel])
}

/// #Слой бизнес логики модуля Basket
final class BasketInteractor {

    /// Модели рецептов
    private var models: [RecipeProtocol] = []
    /// Модели ингредиентов
    private var ingredients: [IngredientViewModel] = []

    weak var presenter: BasketBusinessLogicDelegate?

    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBRecipeManagement & DBIngredientsManagement
    private let ingredientManager: ShopListCalculatable

    init(imageDownloader: ImageDownloadProtocol,
         storage: DBRecipeManagement & DBIngredientsManagement,
         ingredientManager: ShopListCalculatable) {
        self.imageDownloader = imageDownloader
        self.storage = storage
        self.ingredientManager = ingredientManager
    }

    /// Получает ингредиенты для Шоп-листа
    private func getIngredients(complection: @escaping ([IngredientViewModel]) -> Void) {
        let ingredients = models.map {
            $0.ingredients ?? []
        }.reduce([], +)

        ingredientManager.getShopList(ingredients: ingredients,
                                      complection: complection)
    }
}

// MARK: - BasketBusinessLogic
extension BasketInteractor: BasketBusinessLogic {

    func fetchRecipeFromBasket(completion: @escaping ([RecipeViewModel]) -> Void) {
        storage.fetchRecipes(for: .inBasket) { [weak self] recipes in
            self?.models = recipes
            let viewModels = recipes.map { RecipeViewModel(with: $0) }
            completion(viewModels)
        }
    }

    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void) {
        guard !models.isEmpty else { return }
        getIngredients { [weak self] ingredients in
            self?.ingredients = ingredients
            completion(ingredients)
        }
    }

    func changeIsCheck(id: Int, flag: Bool) {
        guard let index = ingredients.firstIndex(where: {$0.id == id}) else { return }
        ingredients[index].isCheck = flag
        presenter?.handOver(ingredients: ingredients)
    }

    func addIngredientsInFridge() {
        let checkIngredients = ingredients.filter { $0.isCheck == true }
        storage.save(ingredients: checkIngredients)
    }

    // RecipeReceived
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }

    // RecipeRemovable
    func removeRecipe(id: Int) {
        guard let index = models.firstIndex(where: {$0.id == id}) else { return }
        models.remove(at: index)
        storage.remove(id: id, for: .inBasket)
    }

    // ImageBusinessLogic
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        switch type {
        case .recipe:
            ImageRequest
                .recipe(imageName: imageName)
                .download(with: imageDownloader,
                          completion: completion)
        case .ingredient:
            ImageRequest
                .ingredient(imageName: imageName, size: .mini)
                .download(with: imageDownloader,
                          completion: completion)
        }
    }
}
