//
//  RecipeListInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логики модуля RecipeList
final class RecipeListInteractor {

    private var models: [RecipeProtocol] = []
    private var favoriteArrayId: [Int] = []

    private let dataFetcher: DataFetcherProtocol
    private let imageDownloader: ImageDownloadProtocol
    private let translateService: Translatable

    private let storage: DBRecipeManagement & DBIngredientsManagement

    init(dataFetcher: DataFetcherProtocol,
         imageDownloader: ImageDownloadProtocol,
         translateService: Translatable,
         storage: DBRecipeManagement & DBIngredientsManagement) {
        self.dataFetcher = dataFetcher
        self.imageDownloader = imageDownloader
        self.translateService = translateService
        self.storage = storage
    }
}

// MARK: - RecipeListBusinessLogic
extension RecipeListInteractor: RecipeListBusinessLogic {

    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {

        RecipeRequest
            .complex(parameters, number, query)
            .downloadRecipes(with: dataFetcher) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response): // Успех
                    guard let recipes = response.results,
                          !recipes.isEmpty else {
                        completion(.failure(.noResults))
                        return }
                    self.convert(recipes: recipes, completion: completion)

                case .failure(let error): // Ошибка
                    completion(.failure(error))
                }
            }
    }

    func fetchRecommended(number: Int,
                          completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        /// Получаем названия имеющихся ингредиентов
        var ingredientTitles: [String] = []
        storage.fetchIngredients(toUse: false) { ingredients in
            ingredientTitles = ingredients.map { $0.name }
        }

        /// Дефолтные параметры
        var parameters = RecipeFilterParameters()
        parameters.type = ["dessert"]

        guard !ingredientTitles.isEmpty else {
            /// Загрузка рекомендаций по дефолту, если холодильник пуст
            fetchRecipe(with: parameters, number: number, query: nil, completion: completion)
            return
        }

        if currentAppleLanguage() != "en" {
            translateService.translate(with: ingredientTitles,
                                       source: currentAppleLanguage(),
                                       target: "en") { [weak self] result in
                switch result {
                case .success(let response):
                    /// При успешном переводе
                    let titles = response.translations.map { $0.text }
                    self?.fetchRecipe(ingredientTitles: titles, number: number, completion: completion)

                case .failure(let error):
                    /// При ошибке
                    completion(.failure(error))
                    self?.fetchRecipe(with: parameters, number: number, query: nil, completion: completion)
                }
            }
        } else {
            /// Если установлен английский
            fetchRecipe(ingredientTitles: ingredientTitles, number: number, completion: completion)
        }
    }

    func saveRecipe(id: Int,
                    for target: TargetOfSave) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        favoriteArrayId.append(id)
        storage.save(recipe: model, for: target)
    }

    func updateFavoriteId() {
        storage.fetchFavoriteId { [weak self] arrayId in
            self?.favoriteArrayId = arrayId
        }
    }

    func checkFavorite(id: Int) -> Bool {
        favoriteArrayId.contains(id) ? true : false
    }

    // RecipeReceived
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void) {
        guard var recipe = models.first(where: { $0.id == id }) as? Recipe else { return }

        if favoriteArrayId.contains(id) {
            recipe.isFavorite = true
        }
        completion(recipe)
    }

    // ImageBusinessLogic
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }

    // RecipeRemovable
    func removeRecipe(id: Int) {
        if let index = favoriteArrayId.firstIndex(where: {$0 == id}) {
            favoriteArrayId.remove(at: index)
        }
        storage.remove(id: id, for: .isFavorite)
    }
}

/// #Вспомогательные приватные функции
extension RecipeListInteractor {
    /// Получает рецепты по id
    /// - Parameters:
    ///  - ids: идентификаторы рецептов
    ///  - completion: захватывает вью-модели/ошибку
    private func fetchRecipes(by ids: [Int],
                              completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        RecipeRequest.byId(ids).downloadById(with: dataFetcher) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.convert(recipes: recipes, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    /// Получает рецепты по информации о ингредиентах
    /// - Parameters:
    ///  - ingredientTitles: названия ингредиентов
    ///  - number: количество рецептов
    ///  - completion: захватывает вью-модели/ошибку
    private func fetchRecipe(ingredientTitles: [String],
                             number: Int,
                             completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        RecipeRequest
            .byIngredients(ingredientTitles, number)
            .downloadIds(with: self.dataFetcher) { [weak self] result in

                switch result {
                case .success(let response):
                    let ids = response.map { $0.id }
                    self?.fetchRecipes(by: ids, completion: completion)

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    /// Преобразует dto-рецепты во вью-модели
    /// - Parameters:
    ///  - recipes: dto-рецепты
    ///  - completion: захватывает вью-модели/ошибку
    private func convert(recipes: [Recipe],
                         completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        var recipes = recipes

        /// Изменяем флаг isFavorite, если рецепт записан в избранные
        for index in 0..<recipes.count where favoriteArrayId.contains(recipes[index].id) {
            recipes[index].isFavorite = true
        }

        /// Если установленный язык не базовый пробуем выполнить перевод
        if currentAppleLanguage() != "en" {
            translateService.fetchTranslate(recipes: recipes,
                                            sourse: "en",
                                            target: "\(currentAppleLanguage())") { [weak self] result in
                switch result {
                case .success(let newRecipes):
                    self?.addModels(recipes: newRecipes, completion: completion)

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            /// Если перевода не требуется
            self.addModels(recipes: recipes, completion: completion)
        }
    }

    /// Добавляет и захватывает рецепты
    private func addModels(recipes: [Recipe],
                           completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        models.append(contentsOf: recipes)

        let viewModels = recipes.map {
            RecipeViewModel(with: $0)
        }
        completion(.success(viewModels))
    }

    /// Проверяет установленный на устройстве язык
    private func currentAppleLanguage() -> String {
        let appleLanguageKey = "AppleLanguages"
        let userdef = UserDefaults.standard
        var currentWithoutLocale = "Base"
        if let langArray = userdef.object(forKey: appleLanguageKey) as? [String] {
            if var current = langArray.first {
                if let range = current.range(of: "-") {
                    current = String(current[..<range.lowerBound])
                }
                currentWithoutLocale = current
            }
        }
        return currentWithoutLocale
    }
}
