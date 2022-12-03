//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//


import Foundation

/// Протокол управления бизнес логикой модуля RecipeList
protocol RecipeListBusinessLogic {
    func translate(texts: [String])
    
    func fetchRandomRecipe(number: Int, tags: [String],
                           completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void)
    func fetchRecipe(with parameters: RecipeFilterParameters, number: Int, query: String?,
                     completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void)
    
    func fetchImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func getModel(id: Int, completion: @escaping (Recipe) -> Void)
}

/// Слой бизнес логики модуля RecipeList
final class RecipeListInteractor {
    weak var presenter: RecipeListBusinessLogicDelegate?
    private let dataFetcher: DFM
    
    private var models: [Recipe] = []
    
    init(dataFetcher: DFM) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - BusinessLogic
extension RecipeListInteractor: RecipeListBusinessLogic {
    
    func getModel(id: Int, completion: @escaping (Recipe) -> Void) {
        guard let model = models.first(where: { $0.id == id
        }) else { return }
        completion(model)
    }
    
    func fetchImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        dataFetcher.fetchRecipeImage(imageName, completion: completion)
    }
    
    func translate(texts: [String]) {
        
        let trPar = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                        texts: texts,
                                        sourceLanguageCode: "en",
                                        targetLanguageCode: "ru")
        dataFetcher.translate(with: trPar) { result in
            switch result {
            case .success(let translate):
                let texts = translate.translations.map {$0.text}
                print(texts)
            case .failure(_):
                print("Error!")
            }
        }
    }
    
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
    
    func fetchRandomRecipe(number: Int, tags: [String],
                           completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void) {
        dataFetcher.fetchRandomRecipe(number: number, tags: tags) { [weak self] result in
            switch result {
                
            case .success(let recipe):
                guard let recipes = recipe.recipes else { return }
                
                if self?.currentAppleLanguage() != "Base"  {
                    let texts = recipes.map { $0.title }
                    let translateParameters = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                                                  texts: texts,
                                                                  sourceLanguageCode: "en",
                                                                  targetLanguageCode: "ru")
                    self?.dataFetcher.translate(with: translateParameters) { result in
                        switch result {
                            
                        case .success(let translate):
                            let texts = translate.translations.map{ $0.text }
                            
                            var arrayModels = [RecipeModel]()
                            
                            (0..<recipes.count).forEach {
                                
                                let recipeCellModel = RecipeModel(id: recipes[$0].id,
                                                                  title: texts[$0],
                                                                  ingredientsCount: recipes[$0].extendedIngredients?.count ?? 0 ,
                                                                  imageName: self?.getImageName(from: recipes[$0].image),
                                                                  isFavorite: false,
                                                                  readyInMinutes: recipes[$0].readyInMinutes )
                                
                                arrayModels.append(recipeCellModel)
                            }
                            completion(.success(arrayModels))
                        case .failure(_):
                            break
                        }
                    }
                }
                
                
            case .failure(let error):
                switch error {
                    
                case .failedToEncode:
                    print(1)
                case .failedToDecode:
                    print(2)
                case .failedToLoadData:
                    print(3)
                case .failedToTranslate:
                    print(4)
                case .wrongUrl:
                    print(5)
                case .wrongStatusCode:
                    print(6)
                case .notInternet:
                    print(7)
                case .failedToLoadImage:
                    print(8)
                }
            }
        }
    }
    
    func fetchRecipe(with parameters: RecipeFilterParameters, number: Int, query: String?,
                     completion: @escaping (Result<[RecipeModel], DataFetcherError>) -> Void) {
        dataFetcher.fetchComplexRecipe(parameters, number, query) { [weak self] result in
            switch result {
                
            case .success(let recipe):
                guard let recipes = recipe.results else {
                    return
                }
                
                self?.models.append(contentsOf: recipes)
                
                if self?.currentAppleLanguage() != "Base"  {
                    let texts = recipes.map { $0.title }
                    let translateParameters = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                                                  texts: texts,
                                                                  sourceLanguageCode: "en",
                                                                  targetLanguageCode: "ru")
                    self?.dataFetcher.translate(with: translateParameters) { result in
                        switch result {
                            
                        case .success(let translate):
                            let texts = translate.translations.map{ $0.text }
                            
                            var arrayModels = [RecipeModel]()
                            
                            (0..<recipes.count).forEach {
                                
                                let recipeCellModel = RecipeModel(id: recipes[$0].id,
                                                                  title: texts[$0],
                                                                  ingredientsCount: recipes[$0].extendedIngredients?.count ?? 0 ,
                                                                  imageName: self?.getImageName(from: recipes[$0].image),
                                                                  isFavorite: false,
                                                                  readyInMinutes: recipes[$0].readyInMinutes)
                                
                                arrayModels.append(recipeCellModel)
                            }
                            completion(.success(arrayModels))
                        case .failure(_):
                            break
                        }
                    }
                }
            case .failure(let error):
                switch error {
                    
                case .failedToEncode:
                    print(1)
                case .failedToDecode:
                    print(2)
                case .failedToLoadData:
                    print(3)
                case .failedToTranslate:
                    print(4)
                case .wrongUrl:
                    print(5)
                case .wrongStatusCode:
                    print(6)
                case .notInternet:
                    print(7)
                case .failedToLoadImage:
                    print(8)
                }
            }

        }
    }
}
