//
//  RecipeFilterPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления слоем навигации модуля RecipeFilter
protocol RecipeFilterRouting {
    /// Перейти на предыдущий экран
    func routeToBack()
}

/// #Протокол управления View-слоем модуля RecipeFilter
protocol RecipeFilterViewable: AnyObject {
    /// Обновление UI
    func updateCV(models: [RecipeFilterParameter: [TagModel]])
    
    func update(section: Int)
    
    func showTFAlert(parameter: RecipeFilterParameter, text: String)
    /// Показать ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля RecipeFilter
protocol RecipeFilterBusinessLogic {
    func fetchFilterParameters(completion: @escaping ([RecipeFilterParameter: [TagModel]]) -> Void)
    
    func fetchText(with parameter: RecipeFilterParameter, completion: @escaping (String) -> Void)
    
    func checkFlag(indexPath: IndexPath) -> Bool
    
    func changeFlag(_ flag: Bool, indexPath: IndexPath)
    
    func update(parameter: RecipeFilterParameter,
                text: String,
                completion: @escaping ([RecipeFilterParameter : [TagModel]]) -> Void)
}

// MARK: - Presenter
/// #Слой презентации модуля RecipeFilter
final class RecipeFilterPresenter {
    
    weak var view: RecipeFilterViewable?
    
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
    func update(parameter: RecipeFilterParameter,
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
        
        guard let parameter = RecipeFilterParameter.allCases.first(where: { $0.rawValue == section }) else { return }
        
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
