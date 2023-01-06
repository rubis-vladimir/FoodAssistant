//
//  DetailInfoPresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления слоем навигации модуля DetailInfo
protocol DetailInfoRouting {
    /// Вернуться назад
    func routeToBack()
}

/// #Протокол управления View-слоем модуля DetailInfo
protocol DetailInfoViewable: AnyObject {
    
    /// Показать таймер
    func showTimer()
}

/// #Протокол управления бизнес логикой модуля DetailInfo
protocol DetailInfoBusinessLogic: ImageBusinessLogic {
    
    /// Обновить флаг избранного рецепта
    /// - Parameters:
    ///  - flag: флаг
    ///  - recipe: рецепт
    func updateFavotite(_ flag: Bool,
                        recipe: RecipeProtocol)
    /// Проверить ингредиент
    func checkFor(ingredient: IngredientViewModel) -> Bool
}

// MARK: - Presenter
/// #Слой презентации модуля DetailInfo
final class DetailInfoPresenter {
    private(set) var recipe: RecipeProtocol
    
    private let interactor: DetailInfoBusinessLogic
    private let router: DetailInfoRouting
    
    weak var view: DetailInfoViewable?
    
    init(interactor: DetailInfoBusinessLogic,
         router: DetailInfoRouting,
         recipe: RecipeProtocol) {
        self.interactor = interactor
        self.router = router
        self.recipe = recipe
    }
}

// MARK: - DetailInfoPresentation
extension DetailInfoPresenter: DetailInfoPresentation {
        
    func didTapChangeFavoriteButton(_ flag: Bool) {
        interactor.updateFavotite(flag, recipe: recipe)
    }
    
    func checkFor(ingredient: IngredientViewModel) -> Bool {
        interactor.checkFor(ingredient: ingredient)
    }
    
    // ImagePresentation
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                /// Пока не обрабатывается
                print(error.localizedDescription)
            }
        }
    }
    
    // BackTappable
    func didTapBackButton() {
        router.routeToBack()
    }
    
    // TimerTapable
    func didTapTimerButton(step: Int) {
        view?.showTimer()
    }
}
