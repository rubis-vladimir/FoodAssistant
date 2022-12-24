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
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// #Протокол управления бизнес логикой модуля RecipeFilter
protocol RecipeFilterBusinessLogic {
    
}

// MARK: - Presenter
/// #Слой презентации модуля RecipeFilter
final class RecipeFilterPresenter {
    weak var delegate: RecipeFilterViewable?
    private let interactor: RecipeFilterBusinessLogic
    private let router: RecipeFilterRouting
    
    init(interactor: RecipeFilterBusinessLogic,
         router: RecipeFilterRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - RecipeFilterPresentation
extension RecipeFilterPresenter: RecipeFilterPresentation {
    
}

