//
//  TranslateService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 05.12.2022.
//

import Foundation

/// #Протокол перевода текста 
protocol Translatable {
    /// Получает массив рецептов с переведенными текстами
    ///  - Parameters:
    ///   - recipes: рецепты до перевода
    ///   - source: из какого языка
    ///   - target: в какой язык
    ///   - completion: захватывает рецепты с переводом / ошибку
    func fetchTranslate(recipes: [Recipe],
                        sourse: String,
                        target: String,
                        completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void)

    /// Запрос на перевод
    ///  - Parameters:
    ///   - texts: строки для перевода
    ///   - source: из какого языка
    ///   - target: в какой язык
    ///   - completion: захватывает ответ с переводом / ошибку
    func translate(with texts: [String],
                   source: String,
                   target: String,
                   completion: @escaping (Result<TranslateResponce, DataFetcherError>) -> Void)
}

/// #Сервис перевода
final class TranslateService {
    /// Словарь содержащий количество символов
    private var symbolsCount: [String: Int] = [:]

    private let dataFetcher: DataFetcherProtocol

    init(dataFetcher: DataFetcherProtocol) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - Translatable
extension TranslateService: Translatable {

    func fetchTranslate(recipes: [Recipe],
                        sourse: String,
                        target: String,
                        completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void) {
        var newRecipes: [Recipe] = []

        let dispatchGroup = DispatchGroup() /// Создаем диспатч-группу

        recipes.forEach { recipe in
            dispatchGroup.enter() /// Входим в группу

            /// Получаем массив текстов, которые нужно перевести
            let texts = takeForTranslate(recipe: recipe)

            /// Отправляем на перевод
            translate(with: texts,
                      source: sourse,
                      target: target) { [weak self] result in
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

                    print(error.localizedDescription)
                    completion(.failure(.translateError))

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

    func translate(with texts: [String],
                   source: String,
                   target: String,
                   completion: @escaping (Result<TranslateResponce, DataFetcherError>) -> Void) {
        let parameters = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                             texts: texts,
                                             sourceLanguageCode: source,
                                             targetLanguageCode: target)

        LanguageRequest
            .translate(patameters: parameters)
            .download(with: dataFetcher, completion: completion)
    }
}

/// #Вспомогательные функции
private extension TranslateService {
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
            symbolsCount["ingredientTitles \(recipe.id)"] = ingredients.count
        }

        /// Шаги приготовления по инструкции
        if let steps = recipe.analyzedInstructions?.first?.steps {
            let stepTitles = steps.map { $0.step }
            arrayString.append(contentsOf: stepTitles)
            symbolsCount["steps \(recipe.id)"] = steps.count
        }

        return arrayString
    }

    /// Заменяет тексты в рецепте на переведенные
    ///  - Parameters:
    ///   - recipe: изначальный рецепт
    ///   - texts: переведенные строки
    ///  - Returns: обновленный рецепт
    private func changeModels(_ recipe: Recipe,
                              with texts: [String]) -> Recipe {
        var recipe = recipe

        /// Название рецепта
        recipe.title = texts[0]

        /// Названия ингредиентов
        if let count = symbolsCount["ingredientTitles \(recipe.id)"],
           count == recipe.extendedIngredients?.count {
            let ingredientTexts = texts.dropFirst().prefix(count).map {String($0)}

            for index in 0..<count {
                recipe.extendedIngredients?[index].name = ingredientTexts[index]
            }
        }

        /// Шаги приготовления по инструкции
        if let count = symbolsCount["steps \(recipe.id)"],
           count == recipe.analyzedInstructions?[0].steps.count {
            let instructionTexts = texts.suffix(count).map {String($0)}

            for index in 0..<count {
                recipe.analyzedInstructions?[0].steps[index].step = instructionTexts[index]
            }
        }
        return recipe
    }
}
