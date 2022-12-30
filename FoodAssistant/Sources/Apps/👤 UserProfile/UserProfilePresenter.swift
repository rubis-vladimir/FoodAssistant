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
    case detailInfo(_ recipe: RecipeProtocol)
}

/// #Протокол управления слоем навигации модуля UserProfile
protocol UserProfileRouting {
    /// Перейти к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: UserProfileTarget)
}

/// #Протокол управления View-слоем модуля UserProfile
protocol UserProfileViewable: ErrorShowable,
                              AnyObject {
    /// Обновить `Collection View`
    func updateCV(orderSection: [UPSectionType])
    /// Скрыть `Search Bar`
    func hideSearchBar(shouldHide: Bool)
    /// Показать алерт добавления ингредиента
    func showAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void)
    /// Перезагрузить элементы
    func reload(items: [IndexPath])
}

/// #Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic: RecipeReceived,
                                   ImageBusinessLogic,
                                   IngredientFetchable,
                                   InBasketAdded,
                                   RecipeRemovable {
    
    /// Получить ингредиенты
    /// - Parameters:
    ///  - text: текст в поисковом баре
    ///  - completion: захватывает вьюмодели рецептов
    func fetchFavoriteRecipe(text: String,
                             completion: @escaping ([RecipeViewModel]) -> Void)
    
    /// Найти ингредиент (для определения идентификатора)
    /// - Parameters:
    ///  - ingredient: вью-модель ингредиента
    ///  - flag: флаг использования
    func find(ingredient: IngredientViewModel,
              completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void)
    
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
    /// Текущий сегмент
    private var currentSegmentIndex = 0
    /// Вью-модели рецептов
    private var viewModels: [RecipeViewModel] = [] {
        didSet {
            guard currentSegmentIndex == 2 else { return }
            view?.updateCV(orderSection: [.favorite(viewModels)])
        }
    }
    /// Вью-модели ингредиентов
    private var ingredients: [IngredientViewModel] = []
    
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
    
    func didTapAddIngredientButton() {
        view?.showAlert(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let ingredient):
                self.interactor.find(ingredient: ingredient) { result in
                    
                    switch result {
                    case .success(let newViewModel):
                        self.ingredients.append(newViewModel)
                        self.view?.updateCV(orderSection: [.fridge(self.ingredients)])
                        
                    case .failure(let error):
                        self.view?.show(error: error)
                    }
                }
                
            case .failure(let error):
                self.view?.show(error: error)
            }
        })
    }
    
    func textEntered(_ text: String) {
        interactor.fetchFavoriteRecipe(text: text) {[weak self] models in
            self?.viewModels = models
        }
    }
    
    func checkFlag(id: Int) -> Bool {
        guard let index = ingredients.firstIndex(where: { $0.id == id }) else { return false }
        return ingredients[index].toUse
    }
    
    // ViewAppearable
    func viewAppeared() {
        didSelectSegment(index: currentSegmentIndex)
    }
    
    // SegmentedViewDelegate
    func didSelectSegment(index: Int) {
        
        guard index != currentSegmentIndex else { return }
        
        switch index {
        /// вкладка профиля
        case 0:
            view?.hideSearchBar(shouldHide: true)
            view?.updateCV(orderSection: [.profile])
            
        /// вкладка холодильника
        case 1:
            interactor.fetchIngredients { ingredients in
                self.ingredients = ingredients
            }
            
            view?.hideSearchBar(shouldHide: true)
            view?.updateCV(orderSection: [.fridge(ingredients)])
        
        /// вкладка избранных рецептов
        default:
            view?.hideSearchBar(shouldHide: false)
            view?.updateCV(orderSection: [.favorite(viewModels)])
        }
        
        currentSegmentIndex = index
    }
    
    // ImagePresentation
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName, type: type) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                self?.view?.show(error: error)
            }
        }
    }
    
    // RecipeRemovable
    func didTapDeleteButton(id: Int) {
        interactor.removeRecipe(id: id)
        
        guard let index = viewModels.firstIndex(where: {$0.id == id} ) else { return }
        viewModels.remove(at: index)
    }
    
    // InBasketAdded
    func didTapAddInBasketButton(id: Int) {
        interactor.addToBasket(id: id)
    }
    
    // SelectedCellDelegate
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] recipe in
            self?.router.route(to: .detailInfo(recipe))
        }
    }
    
    // CheckChangable
    func didTapCheckButton(id: Int, flag: Bool) {
        interactor.changeToUse(id: id, flag: flag)
    }
}
