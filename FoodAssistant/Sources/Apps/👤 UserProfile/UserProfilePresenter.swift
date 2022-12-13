//
//  UserProfilePresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation


/// #Протокол управления View-слоем
protocol UserProfileViewable: AnyObject {
    /// Обновление UI
    func updateUI(with type: UPBuildType)
    /// Показать ошибку
    func showError()
    
    func reloadSection(_ section: Int)
}

/// #Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic {
    
    func getModel(id: Int,
                  completion: @escaping (RecipeProtocol) -> Void)
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchRecipeImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                              completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchRecipeFromDB(completion: @escaping ([RecipeViewModel]) -> Void)
    
}

/// #Навигация в модуле
enum UserProfileTarget {
    /// Детальная информация
    case detailInfo
}

/// #Протокол управления слоем навигации модуля
protocol UserProfileRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: UserProfileTarget, model: RecipeProtocol)
}

/// #Слой презентации модуля UserProfile
final class UserProfilePresenter {
    
    private var currentSegmentIndex = 0
    
    var viewModels: [RecipeViewModel] = []
    {
        didSet {
            guard currentSegmentIndex == 2 else { return }
            delegate?.updateUI(with: .favorite(viewModels))
        }
    }
    
    weak var delegate: UserProfileViewable?
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
    
    func didSelectItem(index: Int) {
        currentSegmentIndex = index
        
        switch index {
        case 0:
            delegate?.updateUI(with: .profile)
        case 1:
            let ingredient1 = Ingredient(id: 12312, image: "cinnamon.jpg", name: "cinnamon", amount: 3)
            let ingredient2 = Ingredient(id: 23233, image: "egg", name: "egg", amount: 5)
            let ingredient3 = Ingredient(id: 4552, image: "red-delicious-apples.jpg", name: "red delicious apples", amount: 1, unit: "кг")
            delegate?.updateUI(with: .fridge([ingredient1, ingredient2, ingredient3]))
        default:
            delegate?.updateUI(with: .favorite(viewModels))
        }
    }
    
    func fetchRecipe() {
        interactor.fetchRecipeFromDB { [weak self] models in
            self?.viewModels = models
        }
    }
    
    func fetchRecipeImage(with imageName: String, completion: @escaping (Data) -> Void) {
        interactor.fetchRecipeImage(imageName) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchIngredientImage(with imageName: String, size: ImageSize, completion: @escaping (Data) -> Void) {
        interactor.fetchIngredientImage(imageName, size: size) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UserProfilePresenter  {
    func didTapAddIngredientsButton(id: Int) {
    }
    
    func didTapFavoriteButton(_ isFavorite: Bool, id: Int) {
    }
    
    func didTapChangeLayoutButton(section: Int) {
        NotificationCenter.default
                    .post(name: NSNotification.Name("changeLayoutType2"),
                     object: nil)
        
        delegate?.reloadSection(section)
    }
    
    func didSelectItem(id: Int) {
        interactor.getModel(id: id) { [weak self] model in
            self?.router.route(to: .detailInfo, model: model)
        }
    }
}
