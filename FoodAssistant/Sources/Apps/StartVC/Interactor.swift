//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

typealias DFM = DataFetcherTranslateManagement & DataFetcherRecipeManagement

import Foundation

/// Протокол управления бизнес логикой модуля
protocol BusinessLogic {
    func translate(texts: [String])
    
    func fetchRandomRecipe(number: Int, tags: [String])
    func fetchRecipe(with parameters: RecipeFilterParameters, number: Int, query: String?)
}

/// Слой бизнес логике модуля
final class Interactor {
    weak var presenter: BusinessLogicDelegate?
    private let dataFetcher: DFM
    
    init(dataFetcher: DFM) {
        self.dataFetcher = dataFetcher
    }
    
    
}

// MARK: - BusinessLogic
extension Interactor: BusinessLogic {
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
    
    func fetchRandomRecipe(number: Int, tags: [String]) {
        dataFetcher.fetchRandomRecipe(number: number, tags: tags) { result in
            switch result {
                
            case .success(let recipe):
                print(recipe)
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
                }
            }
        }
    }
    
    func fetchRecipe(with parameters: RecipeFilterParameters, number: Int, query: String?) {
        dataFetcher.fetchComplexRecipe(parameters, number, query) { result in
            switch result {
                
            case .success(let recipe):
                print(recipe)
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
                }
            }

        }
    }
}
