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
    /// Перейти к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: UserProfileTarget, model: RecipeProtocol)
}

/// #Протокол управления View-слоем модуля UserProfile
protocol UserProfileViewable: AnyObject {
    /// Обновление `Collection View`
    func updateCV(orderSection: [UPSectionType])
    /// Скрыть `Search Bar`
    func hideSearchBar(shouldHide: Bool)
    
    func showAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void)
    /// Показать ошибку
    func showError()
    /// Перезагрузить элементы
    func reload(items: [IndexPath])
}

/// #Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic: RecipeReceived,
                                   ImageBusinessLogic,
                                   UserProfileRecipeBL,
                                   UserProfileIngredientBL { }

/// #Протокол управления рецептами
protocol UserProfileRecipeBL {
    /// Получить ингредиенты
    /// - Parameters:
    ///  - text: текст в поисковом баре
    ///  - completion: захватывает вьюмодели рецептов
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
    
    /// Получить ингредиенты
    /// - Parameter completion: захватывает вьюмодели ингредиентов
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void)
    
    
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
    
    private var currentSegmentIndex = 0
    
    private(set) var viewModels: [RecipeViewModel] = []
    {
        didSet {
            guard currentSegmentIndex == 2 else { return }
            view?.updateCV(orderSection: [.favorite(viewModels)])
        }
    }
    
    private(set) var ingredients: [IngredientViewModel] = [] 
    
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
                    case .failure(_):
                        break
                    }
                    
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func checkFlag(id: Int) -> Bool {
        guard let index = ingredients.firstIndex(where: { $0.id == id }) else { return false }
        return ingredients[index].toUse
    }
    
    
    func fetchFavoriteRecipe(text: String) {
        interactor.fetchFavoriteRecipe(text: text) {[weak self] models in
            self?.viewModels = models
        }
    }
    
    func getNewData() {
        didSelectSegment(index: currentSegmentIndex)
    }
    
    // SegmentedViewDelegate
    func didSelectSegment(index: Int) {
        currentSegmentIndex = index
        
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
                print(error)
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
    
    // LayoutChangable
    func didTapChangeLayoutButton(section: Int) {
        /// Вызываем уведомление изменения layout
        NotificationCenter.default
            .post(name: NSNotification.Name("changeLayoutType2"),
                  object: nil)
        
        let indexPath = (0...viewModels.count-1).map { IndexPath(item: $0, section: section) }
        view?.reload(items: indexPath)
    }
    
    // SelectedCellDelegate
    func didSelectItem(id: Int) {
        interactor.getRecipe(id: id) { [weak self] model in
            self?.router.route(to: .detailInfo, model: model)
        }
    }
    
    // CheckChangable
    func didTapCheckButton(id: Int, flag: Bool) {
        interactor.changeToUse(id: id, flag: flag)
    }
}
