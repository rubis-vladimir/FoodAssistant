//
//  RecipeFilterPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

protocol SeachRecipesRequested: AnyObject {
    
    func search(with parameters: RecipeFilterParameters)
}


/// #Протокол управления слоем навигации модуля RecipeFilter
protocol RecipeFilterRouting {
    /// Перейти на предыдущий экран
    func routeToBack()
}

/// #Протокол управления View-слоем модуля RecipeFilter
protocol RecipeFilterViewable: AnyObject {
    /// Обновление UI
    func updateCV(models: [FilterParameter: [TagModel]])
    
    func update(section: Int)
    
    func showTFAlert(parameter: FilterParameter, text: String)
    /// Показать ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля RecipeFilter
protocol RecipeFilterBusinessLogic {
    func fetchFilterParameters(completion: @escaping ([FilterParameter: [TagModel]]) -> Void)
    
    func fetchText(with parameter: FilterParameter, completion: @escaping (String) -> Void)
    
    func getParameters(completion: @escaping (RecipeFilterParameters) -> Void)
    
    func checkFlag(indexPath: IndexPath) -> Bool
    
    func changeFlag(_ flag: Bool, indexPath: IndexPath)
    
    func update(parameter: FilterParameter,
                text: String,
                completion: @escaping ([FilterParameter : [TagModel]]) -> Void)
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
    
    func getStartData() {
        interactor.fetchFilterParameters { [weak self] parameters in
            self?.view?.updateCV(models: parameters)
        }
    }
}

// MARK: - RecipeFilterPresentation
extension RecipeFilterPresenter: RecipeFilterPresentation {
    func didTapShowResultButton() {
        
        interactor.getParameters { [weak self] parameters in
            self?.rootPresenter?.search(with: parameters)
            self?.router.routeToBack()
        }
    }
    
    func update(parameter: FilterParameter,
                text: String) {
        interactor.update(parameter: parameter,
                          text: text) { [weak self] parameters in
            self?.view?.updateCV(models: parameters)
        }
    }
    
    func checkFlag(indexPath: IndexPath) -> Bool {
        interactor.checkFlag(indexPath: indexPath)
    }
    
    func changeSelectedIngredients(section: Int) {
        print("changeSelectedIngredients \(section)")
        
        guard let parameter = FilterParameter.allCases.first(where: { $0.rawValue == section }) else { return }
        
        interactor.fetchText(with: parameter) { [weak self] text in
            self?.view?.showTFAlert(parameter: parameter, text: text)
        }
        
    }
    
    func didTapElementCell(_ flag: Bool, indexPath: IndexPath) {
        print("didTapElementCell \(flag) + \(indexPath.section)")
        interactor.changeFlag(flag, indexPath: indexPath)
    }
}

extension RecipeFilterPresenter: RecipeFilterBusinessLogicDelegate {
    func update(section: Int) {
        view?.update(section: section)
    }
}
