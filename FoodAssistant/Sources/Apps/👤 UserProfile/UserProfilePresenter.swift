//
//  UserProfilePresenter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Навигация в модуле UserProfile
enum UserProfileTarget {
    /// Детальная информация
    case detailInfo
}

/// #Протокол управления слоем навигации модуля UserProfile
protocol UserProfileRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: UserProfileTarget, model: RecipeProtocol)
}

/// #Протокол управления View-слоем модуля UserProfile
protocol UserProfileViewable: AnyObject {
    /// Обновление `Collection View`
    func updateCV(orderSection: [UPSectionType])
    /// Скрыть `Search Bar`
    func hideSearchBar(shouldHide: Bool)
    /// Показать ошибку
    func showError()
    
    func reloadSection(_ section: Int)
}

/// #Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic: RecipeReceived,
                                   ImageBusinessLogic,
                                   UserProfileRecipeBL,
                                   UserProfileIngredientBL { }

/// #Протокол управления рецептами
protocol UserProfileRecipeBL {
    func fetchFavoriteRecipe(text: String,
                             completion: @escaping ([RecipeViewModel]) -> Void)
    
    /// Удалить рецепт
    /// - Parameter id: идентификатор рецепта
    func removeRecipe(id: Int)
    
    /// Добавить в корзину
    /// - Parameter id: идентификатор рецепта
    func addToBasket(id: Int)
}

/// #Протокол управления ингредиентами
protocol UserProfileIngredientBL {
    /// Изменить флаг использования ингредиента
    /// - Parameters:
    ///  - id: идентификатор ингредиента
    ///  - flag: флаг использования
    func changeToUse(id: Int, flag: Bool)
    
    /// Сохранить ингредиент
    /// - Parameter ingredient: ингредиент
    func save(ingredient: IngredientProtocol)
    
    /// Удалить ингредиент
    /// - Parameter id: идентификатор ингредиента
    func deleteIngredient(id: Int)
}


// MARK: - Presenter
/// #Слой презентации модуля UserProfile
final class UserProfilePresenter {
    
    private var currentSegmentIndex = 0
    
    var viewModels: [RecipeViewModel] = []
    {
        didSet {
            guard currentSegmentIndex == 2 else { return }
            view?.updateCV(orderSection: [.favorite(viewModels)])
        }
    }
    
    weak var view: UserProfileViewable?
    private let interactor: UserProfileBusinessLogic
    private let router: UserProfileRouting
    
    init(interactor: UserProfileBusinessLogic,
         router: UserProfileRouting) {
        self.interactor = interactor
        self.router = router
    }
}


// MARK: - UserProfilePresentation
extension UserProfilePresenter: UserProfilePresentation {
    
    func fetchFavoriteRecipe(text: String) {
        interactor.fetchFavoriteRecipe(text: text) {[weak self] models in
            self?.viewModels = models
        }
    }
    
    func didSelectSegment(index: Int) {
        currentSegmentIndex = index
        
        switch index {
        case 0:
            view?.hideSearchBar(shouldHide: true)
            view?.updateCV(orderSection: [.profile])
        case 1:
            let ingredient1 = Ingredient(id: 12312, image: "cinnamon.jpg", name: "cinnamon", dtoAmount: 3)
            let ingredient2 = Ingredient(id: 23233, image: "egg", name: "egg", dtoAmount: 5)
            let ingredient3 = Ingredient(id: 4552, image: "red-delicious-apples.jpg", name: "red delicious apples", dtoAmount: 1, dtoUnit: "кг")
            
            interactor.save(ingredient: ingredient1)
            interactor.save(ingredient: ingredient2)
            interactor.save(ingredient: ingredient3)
            
            let array = [ingredient1, ingredient2, ingredient3].map { IngredientViewModel(ingredient: $0)}
            
            view?.hideSearchBar(shouldHide: true)
            view?.updateCV(orderSection: [.fridge(array)])
        default:
            view?.hideSearchBar(shouldHide: false)
            view?.updateCV(orderSection: [.favorite(viewModels)])
        }
    }
    
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didTapDeleteButton(id: Int) {
        interactor.removeRecipe(id: id)
        
        guard let index = viewModels.firstIndex(where: {$0.id == id} ) else { return }
        viewModels.remove(at: index)
    }
    
    func didTapAddInBasketButton(id: Int) {
        interactor.addToBasket(id: id)
    }
    
    func didTapChangeLayoutButton(section: Int) {
        NotificationCenter.default
            .post(name: NSNotification.Name("changeLayoutType2"),
                  object: nil)
        
        view?.reloadSection(section)
    }
    
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] model in
            self?.router.route(to: .detailInfo, model: model)
        }
    }
    
    func didTapCheckButton(id: Int, flag: Bool) {
        interactor.changeToUse(id: id, flag: flag)
    }
}
