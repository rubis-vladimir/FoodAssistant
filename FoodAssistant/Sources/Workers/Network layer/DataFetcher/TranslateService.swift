//
//  TranslateService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 05.12.2022.
//

import Foundation

/// #Протокол перевода текста для рецептов
protocol RecipeTranslatable {
    /// Получает массив рецептов с переведенными текстами
    ///  - Parameters:
    ///   - recipes: рецепты до перевода
    ///   - completion: захватывает рецепты с переводом / ошибку
    func fetchTranslate(recipes: [Recipe],
                        completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void)
}

/// #Сервис перевода
final class TranslateService {
    private let dataFetcher: DataFetcherProtocol
    
    private var elementsCount: [String : Int] = [:]
    
    init(dataFetcher: DataFetcherProtocol) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - RecipeTranslatable
extension TranslateService: RecipeTranslatable {
    
    func fetchTranslate(recipes: [Recipe],
                        completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void) {
        var newRecipes: [Recipe] = []
        
        let dispatchGroup = DispatchGroup() /// Создаем диспатч-группу
        
        recipes.forEach { recipe in
            guard currentAppleLanguage() != "Base" else { return }
            
            dispatchGroup.enter() /// Входим в группу
           
            /// Получаем массив текстов, которые нужно перевести
            let texts = takeForTranslate(recipe: recipe)
            
            /// Отправляем на перевод
            translate(with: texts) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let responce):
                    /// Если перевод выполнен
                    let texts = responce.translations.map { $0.text }
                    let newRecipe = self.changeModels(recipe,
                                                      with: texts)
                    newRecipes.append(newRecipe)
                    
                    dispatchGroup.leave() /// Выходим из группы
                    
                case .failure(let error):
                    /// Если перевод не удался
                    newRecipes.append(recipe)
                    completion(.failure(error))
                    
                    dispatchGroup.leave() /// Выходим из группы
                }
            }
        }
        
        /// Подписываем на уведомление
        dispatchGroup.notify(queue: .global()) {
            /// Как придут ответы по всем переводам,
            /// возвращаем обновленный массив рецептов
            completion(.success(newRecipes))
        }
    }
}

/// #Вспомогательные функции
private extension TranslateService {
    /// Запрос на перевод
    ///  - Parameters:
    ///   - texts: строки для перевода
    ///   - completion: захватывает ответ с переводом / ошибку
    private func translate(with texts: [String],
                           completion: @escaping (Result<TranslateResponce, DataFetcherError>) -> Void) {
        let parameters = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                             texts: texts,
                                             sourceLanguageCode: "en",
                                             targetLanguageCode: "ru")
        
        LanguageRequest.translate(patameters: parameters).download(with: dataFetcher, completion: completion)
    }
    
    /// Получает массив строк, которые необходимо перевести
    ///  - Parameter recipe: рецепт
    ///  - Returns: массив строк
    private func takeForTranslate(recipe: Recipe) -> [String] {
        var arrayString: [String] = []
        
        /// Название рецепта
        arrayString.append(recipe.title)
        
        /// Названия ингредиентов
        if let ingredients = recipe.extendedIngredients {
            let ingredientTitles = ingredients.map { $0.name }
            arrayString.append(contentsOf: ingredientTitles)
            elementsCount["ingredientTitles"] = ingredientTitles.count
        }
        
        /// Шаги приготовления по инструкции
        if let instructions = recipe.analyzedInstructions {
            let steps = instructions[0].steps.map { $0.step }
            arrayString.append(contentsOf: steps)
            elementsCount["steps"] = steps.count
        }
        
        return arrayString
    }
    
    /// Заменяет тексты в рецепте на переведенные
    ///  - Parameters:
    ///   - recipe: изначальный рецепт
    ///   - texts: переведенные строки
    ///  - Returns: обновленный рецепт
    func changeModels(_ recipe: Recipe,
                      with texts: [String]) -> Recipe {
        var recipe = recipe
        
        /// Название рецепта
        recipe.title = texts[0]
        
        /// Названия ингредиентов
        if let count = elementsCount["ingredientTitles"],
           count == recipe.extendedIngredients?.count {
            let ingredientTexts = texts.dropFirst().prefix(count).map {String($0)}
            
            for index in 0..<count {
                recipe.extendedIngredients?[index].name = ingredientTexts[index]
            }
        }
        
        /// Шаги приготовления по инструкции
        if let count = elementsCount["steps"],
           count == recipe.analyzedInstructions?[0].steps.count {
            let instructionTexts = texts.suffix(count).map {String($0)}
            
            for index in 0..<count-1 {
                recipe.analyzedInstructions?[0].steps[index].step = instructionTexts[index]
            }
        }
        return recipe
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

