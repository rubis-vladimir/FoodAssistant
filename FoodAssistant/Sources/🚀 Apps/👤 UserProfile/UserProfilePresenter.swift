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
    /// - Parameter orderSection: подгружаемая секция
    func updateCV(orderSection: [UPSectionType])
    /// Обновить `Nav Bar`
    /// - Parameter index: выбранный индекс сегмента
    func updateNavBar(index: Int)
    
    /// Обновить секцию с таймерами
    /// - Parameter timers: таймеры
    func updateTimerSection(with timers: [RecipeTimer])
    
    /// Показать алерт добавления ингредиента
    /// - Parameter completion: захватывает модель ингредиента/ ошибку
    func showAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void)
    
    /// Показать алерт с запросом на удаление
    /// - Parameters:
    ///  - text: название удаляемого
    ///  - action: действие удаления
    func showDelete(text: String,
                    action: @escaping (() -> Void))
    
    /// Перезагрузить элементы
    /// - Parameter items: перезагружаемые элементы
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
    func fetchFavoriteRecipe(text: String?,
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
    private var currentSegmentIndex = 1
    /// Последний текст
    private var lastText = ""
    /// Вью-модели рецептов
    private var recipes: [RecipeViewModel] = [] {
        didSet {
            guard currentSegmentIndex == 2 else { return }
            view?.updateCV(orderSection: [.favorite(recipes)])
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
    
    
    func getStart() {
        interactor.fetchIngredients { ingredients in
            self.ingredients = ingredients
        }
        
        view?.updateNavBar(index: currentSegmentIndex)
        view?.updateCV(orderSection: [.fridge(ingredients)])
    }
    
    /// Конфигурирует и показывает восстанавливаемую ошибку
    /// - Parameters:
    ///  - error: ошибка
    ///  - action: действи при восстановлении
    private func showRecoveryError(from error: DataFetcherError,
                                   action: @escaping () -> ()) {
        var actions: [RecoveryOptions] = [.cancel]
        
        switch error {
        case .invalidNumber, .notDataProvided:
            let tryAgainAction = RecoveryOptions.tryAgain(action: action)
            actions.append(tryAgainAction)
        default: break
        }
        
        view?.show(rError: RecoverableError(error: error,
                                            recoveryOptions: actions))
    }
    
    private func updateSelectedSegment(index: Int) {
        switch index {
        /// вкладка профиля
        case 0:
            view?.updateCV(orderSection: [.profile])
            
        /// вкладка холодильника
        case 1:
            interactor.fetchIngredients { ingredients in
                self.ingredients = ingredients
            }
            view?.updateCV(orderSection: [.fridge(ingredients)])
        
        /// вкладка избранных рецептов
        default:
            interactor.fetchFavoriteRecipe(text: lastText) { [weak self] viewModels in
                self?.recipes = viewModels
            }
            view?.updateCV(orderSection: [.favorite(recipes)])
        }
        view?.updateNavBar(index: index)
        
        currentSegmentIndex = index
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
                        /// Пока не обрабатывается
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                switch error {
                case .invalidNumber, .notDataProvided:
                    let action = { self.didTapAddIngredientButton() }
                    self.showRecoveryError(from: error,
                                           action: action)
                default:
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    func textEntered(_ text: String) {
        lastText = text
        
        interactor.fetchFavoriteRecipe(text: text) {[weak self] models in
            self?.recipes = models
        }
    }
    
    func checkFlag(id: Int) -> Bool {
        guard let index = ingredients.firstIndex(where: { $0.id == id }) else { return false }
        return ingredients[index].toUse
    }
    
    // ViewAppearable
    func viewAppeared() {
        updateSelectedSegment(index: currentSegmentIndex)
    }
    
    // SegmentedViewDelegate
    func didSelectSegment(index: Int) {
        
        guard index != currentSegmentIndex else { return }
        updateSelectedSegment(index: index)
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
    
    // RecipeRemovable
    func didTapDeleteButton(id: Int) {
        
        let text = currentSegmentIndex == 1 ? "product" : "recipe"
        
        view?.showDelete(text: text,
                         action: { [weak self] in
            self?.delete(id: id)
        })
    }
    
    private func delete(id: Int) {
        switch currentSegmentIndex {
        case 1:
            interactor.deleteIngredient(id: id)
            
            guard let index = ingredients.firstIndex(where: {$0.id == id} ) else { break }
            ingredients.remove(at: index)
            
        case 2:
            interactor.removeRecipe(id: id)
            
            guard let index = recipes.firstIndex(where: {$0.id == id} ) else { break }
            recipes.remove(at: index)
        default: break
        }
        
        updateSelectedSegment(index: currentSegmentIndex)
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

// MARK: - UserProfileBusinessLogicDelegate
extension UserProfilePresenter: UserProfileBusinessLogicDelegate {
    func updateTimers(timers: [RecipeTimer]) {
        view?.updateTimerSection(with: timers)
    }
}
