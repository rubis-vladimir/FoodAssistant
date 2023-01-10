//
//  RecipeFilterPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол запроса на поиск рецептов
protocol SeachRecipesRequested: AnyObject {
    /// Выполнить поиск рецептов с параметрами
    /// - Parameter parameters: параметры
    func search(with parameters: RecipeFilterParameters)
}

/// #Протокол управления слоем навигации модуля RecipeFilter
protocol RecipeFilterRouting {
    /// Перейти на предыдущий экран
    func routeToBack()
}

/// #Протокол управления View-слоем модуля RecipeFilter
protocol RecipeFilterViewable: AnyObject {
    /// Обновление `Collection View`
    /// - Parameter dictModels: словарь параметров с данными
    func updateCV(dictModels: [FilterParameters: [TagModel]])
    
    /// Обновить секцию
    /// - Parameter section: номер секции
    func update(section: Int)
    
    /// Показать алерт корректировки параметра
    /// - Parameters:
    ///  - parameter: параметр
    ///  - text: текст
    func showTFAlert(parameter: FilterParameters,
                     text: String)
}

/// #Протокол управления бизнес логикой модуля RecipeFilter
protocol RecipeFilterBusinessLogic {
    /// Получить параметры для запроса
    func getParameters(completion: @escaping (RecipeFilterParameters) -> Void)
    
    /// Получить параметры для конфигурации UI
    func fetchFilterParameters(completion: @escaping ([FilterParameters: [TagModel]]) -> Void)
    
    /// Получить текст из данных параметра
    /// - Parameters:
    ///  - parameter: параметр
    ///  - completion: захватывает текст
    func fetchText(with parameter: FilterParameters,
                   completion: @escaping (String) -> Void)
    
    /// Обновить данные параметра
    /// - Parameters:
    ///  - parameter: параметр
    ///  - text: текст
    ///  - completion: захватывает параметр с данными
    func update(parameter: FilterParameters,
                text: String,
                completion: @escaping ([FilterParameters : [TagModel]]) -> Void)
    
    /// Проверка флага выбора тэга
    func checkFlag(indexPath: IndexPath) -> Bool
    
    /// Изменить флаг для конкретного тэга
    /// - Parameters:
    ///  - flag: флаг
    ///  - indexPath: индекс в коллекции
    func changeFlag(_ flag: Bool,
                    indexPath: IndexPath)
}

// MARK: - Presenter
/// #Слой презентации модуля RecipeFilter
final class RecipeFilterPresenter {
    
    weak var view: RecipeFilterViewable?
    weak var rootPresenter: SeachRecipesRequested?
    
    private let interactor: RecipeFilterBusinessLogic
    private let router: RecipeFilterRouting
    
    init(interactor: RecipeFilterBusinessLogic,
         router: RecipeFilterRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    /// Стартовая подгрузка параметров
    func getStartData() {
        interactor.fetchFilterParameters { [weak self] parameters in
            self?.view?.updateCV(dictModels: parameters)
        }
    }
}

// MARK: - RecipeFilterPresentation
extension RecipeFilterPresenter: RecipeFilterPresentation {
    
    func didTapChange(parameter: FilterParameters,
                text: String) {
        interactor.update(parameter: parameter,
                          text: text) { [weak self] parameters in
            self?.view?.updateCV(dictModels: parameters)
        }
    }
    
    func didTapShowResultButton() {
        interactor.getParameters { [weak self] parameters in
            self?.rootPresenter?.search(with: parameters)
            self?.router.routeToBack()
        }
    }
    
    func checkFlag(indexPath: IndexPath) -> Bool {
        interactor.checkFlag(indexPath: indexPath)
    }
    
    // SelectedIngredientsChangable
    func changeSelectedIngredients(section: Int) {
        guard let parameter = FilterParameters.allCases.first(where: { $0.rawValue == section }) else { return }
        
        interactor.fetchText(with: parameter) { [weak self] text in
            self?.view?.showTFAlert(parameter: parameter, text: text)
        }
    }
    
    // CellTapable
    func didTapElementCell(_ flag: Bool,
                           indexPath: IndexPath) {
        interactor.changeFlag(flag,
                              indexPath: indexPath)
    }
    
    // SearchBarFilterDelegate
    func didTapFilterButton() {
        self.router.routeToBack()
    }
}

// MARK: - RecipeFilterBusinessLogicDelegate
extension RecipeFilterPresenter: RecipeFilterBusinessLogicDelegate {
    func update(section: Int) {
        view?.update(section: section)
    }
}
