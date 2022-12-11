//
//  UserProfilePresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol UserProfilePresentation: EventsCellDelegate,
                                  LayoutChangable,
                                  SelectedCellDelegate,
                                  SegmentedViewDelegate,
                                  AnyObject {
    
    var viewModels: [RecipeViewModel] { get }
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchRecipeImage(with imageName: String,
                          completion: @escaping (Data) -> Void)
    func fetchIngredientImage(with imageName: String, size: ImageSize,
                              completion: @escaping (Data) -> Void)
    
    func fetchRecipe()
}

protocol SegmentedViewDelegate {
    func didSelectPage(index: Int)
}


/// Протокол делегата бизнес логики модуля UserProfile
protocol UserProfileBusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля UserProfile
final class UserProfilePresenter {
    
    var viewModels: [RecipeViewModel] = [] {
        didSet {
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

// MARK: - Presentation
extension UserProfilePresenter: UserProfilePresentation {
    
    
    func didSelectPage(index: Int) {
        switch index {
        case 0: print("userProfile")
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

// MARK: - BusinessLogicDelegate
extension UserProfilePresenter: UserProfileBusinessLogicDelegate {
    
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
