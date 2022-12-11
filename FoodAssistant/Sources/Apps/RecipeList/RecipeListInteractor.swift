//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//


import Foundation

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
    func fetchRecipe(with parameters: RecipeFilterParameters, number: Int, query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void)
    
    func fetchRecipes(completion: @escaping ([RecipeProtocol]) -> Void)
    
    func remove(id: Int)
    
    func saveRecipe(id: Int)
}


/// #Слой бизнес логики модуля RecipeList
final class RecipeListInteractor {
    
    private var models: [RecipeProtocol] = []

    private let dataFetcher: DataFetcherProtocol
    private let imageDownloader: ImageDownloadProtocol
    private let translateService: RecipeTranslatable
    
    private let storage: DBRecipeManagement
    
    init(dataFetcher: DataFetcherProtocol,
         imageDownloader: ImageDownloadProtocol,
         translateService: RecipeTranslatable,
         storage: DBRecipeManagement) {
        self.dataFetcher = dataFetcher
        self.imageDownloader = imageDownloader
        self.translateService = translateService
        self.storage = storage
    }
}

// MARK: - RecipeListBusinessLogic
extension RecipeListInteractor: RecipeListBusinessLogic {
    func fetchRecipes(completion: @escaping ([RecipeProtocol]) -> Void) {
        storage.fetchRecipes(completion: completion)
    }
    
    func remove(id: Int) {
        storage.remove(id: id, for: .favorite)
    }
    
    func saveRecipe(id: Int) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        
        storage.save(recipe: model, for: .favorite)
    }
    
    
    func getModel(id: Int,
                  completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }
    
    func fetchImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }
    
   
    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        
        RecipeRequest
            .complexSearch(parameters, number, query)
            .download(with: dataFetcher) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responce):
                guard let recipes = responce.results else { return }
                
                /// Если установленный язык не базовый
                if self.currentAppleLanguage() != "Base" {
                    /// Запрашиваем для рецептов в сервисе
                    self.translateService.fetchTranslate(recipes: recipes) { result in
                        
                        switch result {
                        case .success(let newRecipes):
                            /// Получаем массив рецептов с переведенными текстами
                            
                            
                            self.models.append(contentsOf: newRecipes)
                            
                            let viewModels = newRecipes.map {
                                RecipeViewModel(with: $0)
                            }
                            completion(.success(viewModels))
                            
                        case .failure(let error):
                            /// Ошибки при переводе
                            completion(.failure(error))
                        }
                    }
                } else {
                    /// Если переводить не нужно
                    
                    self.models.append(contentsOf: recipes)
                    let viewModels = recipes.map {
                        RecipeViewModel(with: $0)
                    }
                    
                    completion(.success(viewModels))
                }
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}

/// #Вспомогательные функции
extension RecipeListInteractor {
    /// Получает из url-строки название изображения
    private func getImageName(from urlString: String?) -> String? {
        guard let urlString = urlString else { return nil }
        return String(urlString.dropFirst(37))
    }
    
    /// Преобразует модель рецепта во вью модель
//    private func convertInShortViewModels(recipes: [RecipeProtocol]) -> [RecipeViewModel] {
//        var array: [RecipeViewModel] = []
//
//        recipes.forEach {
//            let recipeModel = RecipeViewModel(id: $0.id,
//                                                   title: $0.title,
//                                                   ingredientsCount: $0.extendedIngredients?.count ?? 0,
//                                                   imageName: getImageName(from: $0.image),
//                                                   isFavorite: false,
//                                                   cookingTime: $0.cookingTime)
//            array.append(recipeModel)
//        }
//        return array
//    }
    
//    private func convertInViewModels(recipes: [Recipe]) -> [RecipeProtocol] {
//        var array: [RecipeViewModel] = []
//        
//        recipes.forEach {
//            let recipeModel = RecipeViewModel(id: $0.id,
//                                              title: $0.title,
//                                              cookingTime: $0.cookingTime,
//                                              servings: $0.servings,
//                                              imageName: $0.image,
//                                              nutrients: $0.nutrition?.nutrients,
//                                              ingredients: $0.extendedIngredients,
//                                              instructionSteps: $0.analyzedInstructions?[0].steps)
//            array.append(recipeModel)
//        }
//        return array
//    }
    
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

