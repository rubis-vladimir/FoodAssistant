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
    private let translateService: RecipeTranslatable
    
    private let storage: DBRecipeManagement & DBIngredientsManagement
    
    init(dataFetcher: DataFetcherProtocol,
         imageDownloader: ImageDownloadProtocol,
         translateService: RecipeTranslatable,
         storage: DBRecipeManagement & DBIngredientsManagement) {
        self.dataFetcher = dataFetcher
        self.imageDownloader = imageDownloader
        self.translateService = translateService
        self.storage = storage
    }
}

// MARK: - RecipeListBusinessLogic
extension RecipeListInteractor: RecipeListBusinessLogic {
    
    // MARK: - RecipeReceived
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }
    
    // MARK: - RLNetworkBusinessLogic
    func fetchRecommended(number: Int,
                          completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        /// Получаем названия имеющихся ингредиентов
        var ingredientTitles: [String] = []
        storage.fetchIngredients(toUse: false) { ingredients in
            ingredientTitles = ingredients.map { $0.name }
        }
        
        /// Отправляем запрос на получения рецептов
        if ingredientTitles.isEmpty {
            let parameters = RecipeFilterParameters()
            fetchRecipe(with: parameters, number: number, query: nil, completion: completion)
        } else {
            fetchRecipe(ingredientTitles: ingredientTitles, number: number, completion: completion)
        }
    }
    
    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        
        RecipeRequest
            .complex(parameters, number, query)
            .downloadRecipes(with: dataFetcher) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let responce): // Успех
                    guard let recipes = responce.results else {
                        /// !!!! Нет рецептов
                        return }
                    self.convert(recipes: recipes, completion: completion)
                    
                case .failure(let error): // Ошибка
                    completion(.failure(error))
                }
            }
    }
    
    private func fetchRecipe(ingredientTitles: [String],
                             number: Int,
                             completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        RecipeRequest
            .byIngredients(ingredientTitles, number)
            .downloadIds(with: self.dataFetcher) { result in
                
                switch result {
                case .success(let responce):
                    let ids = responce.map { $0.id }
                    self.fetchRecipes(by: ids, completion: completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, NetworkFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }
    
    // MARK: - RLLocalStorageBusinessLogic
    func checkFavorite(id: Int) -> Bool {
        favoriteArrayId.contains(id) ? true : false
    }
    
    func updateFavoriteId() {
        storage.fetchFavoriteId { [weak self] arrayId in
            self?.favoriteArrayId = arrayId
        }
    }
    
    func removeRecipe(id: Int) {
        storage.remove(id: id, for: .isFavorite)
    }
    
    func saveRecipe(id: Int, for target: TargetOfSave) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        storage.save(recipe: model, for: target)
    }
}


/// #Вспомогательные приватные функции
extension RecipeListInteractor {
    
    private func fetchRecipes(by ids: [Int], completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        RecipeRequest.byId(ids).downloadById(with: dataFetcher) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.convert(recipes: recipes, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func convert(recipes: [Recipe],
                         completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        var recipes = recipes
        
        /// Изменяем флаг isFavorite, если рецепт записан в избранные
        for i in 0..<recipes.count {
            if self.favoriteArrayId.contains(recipes[i].id) {
                recipes[i].isFavorite = true
            }
        }
        
        /// Если установленный язык не базовый пробуем выполнить перевод
        if self.currentAppleLanguage() != "Base" {
            self.translateService.fetchTranslate(recipes: recipes) { result in
                switch result {
                case .success(let newRecipes):
                    self.addModels(recipes: newRecipes, completion: completion)
                    
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
                           completion: @escaping (Result<[RecipeViewModel], NetworkFetcherError>) -> Void) {
        self.models.append(contentsOf: recipes)
        
        let viewModels = recipes.map {
            RecipeViewModel(with: $0)
        }
        completion(.success(viewModels))
    }
    
    /// Получает из url-строки название изображения
    private func getImageName(from urlString: String?) -> String? {
        guard let urlString = urlString else { return nil }
        return String(urlString.dropFirst(37))
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

