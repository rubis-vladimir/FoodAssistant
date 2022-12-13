//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//


import Foundation




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
        storage.fetchRecipes(for: .favorite, completion: completion)
    }
    
    func removeRecipe(id: Int) {
        storage.remove(id: id, for: .favorite)
    }
    
    func saveRecipe(id: Int, for target: TargetOfSave) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        storage.save(recipe: model, for: target)
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
                /// Получили рецепты из запроса
                guard var recipes = responce.results else { return }
                /// Изменяем флаг isFavorite, если рецепт уже записан в любимые
                for i in 0..<recipes.count {
                    if self.storage.check(id: recipes[i].id) {
                        recipes[i].isFavorite = true
                    }
                }
                
                /// Если установленный язык не базовый
                if self.currentAppleLanguage() != "Base" {
                    /// Запрашиваем перевод для рецептов в сервисе
                    self.translateService.fetchTranslate(recipes: recipes) { result in
                        
                        switch result {
                        case .success(let newRecipes):
                            /// Получили массив рецептов с переведенными текстами
                            self.models.append(contentsOf: newRecipes)
                            
                            let viewModels = newRecipes.map {
                                RecipeViewModel(with: $0)
                            }
                            completion(.success(viewModels))
                            
                        case .failure(let error):
                            /// Если перевод не удался
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
                /// Если запрос рецептов вернул ошибку
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

