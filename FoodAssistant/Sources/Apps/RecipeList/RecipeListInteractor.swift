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
                  completion: @escaping (Recipe) -> Void)
    
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
                     completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void)
}


/// #Слой бизнес логики модуля RecipeList
final class RecipeListInteractor {
    
    private var models: [Recipe] = []

    private let dataFetcher: DataFetcherProtocol
    private let imageDownloader: ImageDownloadProtocol
    private let translateService: RecipeTranslatable
    
    init(dataFetcher: DataFetcherProtocol,
         imageDownloader: ImageDownloadProtocol,
         translateService: RecipeTranslatable) {
        self.dataFetcher = dataFetcher
        self.imageDownloader = imageDownloader
        self.translateService = translateService
    }
}

// MARK: - RecipeListBusinessLogic
extension RecipeListInteractor: RecipeListBusinessLogic {
    
    func getModel(id: Int,
                  completion: @escaping (Recipe) -> Void) {
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
                     completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void) {
        
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
                            
                            let viewModels = self.convertInViewModels(recipes: newRecipes)
                            completion(.success(viewModels))
                            
                        case .failure(let error):
                            /// Ошибки при переводе
                            completion(.failure(error))
                        }
                    }
                } else {
                    /// Если переводить не нужно
                    self.models.append(contentsOf: recipes)
                    
                    let viewModels = self.convertInViewModels(recipes: recipes)
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
    private func convertInViewModels(recipes: [Recipe]) -> [RecipeModel] {
        var array: [RecipeModel] = []
        
        recipes.forEach {
            let recipeModel = RecipeModel(id: $0.id,
                                          title: $0.title,
                                          ingredientsCount: $0.extendedIngredients?.count ?? 0,
                                          imageName: getImageName(from: $0.image),
                                          isFavorite: false,
                                          readyInMinutes: $0.readyInMinutes)
            array.append(recipeModel)
        }
        return array
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

