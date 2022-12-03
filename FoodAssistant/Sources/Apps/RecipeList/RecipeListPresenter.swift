//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Типы моделей данных рецептов
enum RLModelType {
    /// Рекомендованные
    case recommended
    /// Основные
    case main
}

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: RLLayoutChangable, RLCellEventDelegate, AnyObject {
    var viewModels: [RLModelType: [RecipeModel]] { get }
    func testTranslate()
    
    func testGetRandom()
    func testGetRecipe()
    
    func fetchImage(with imageName: String,
                    completion: @escaping (Data) -> Void)
}

/// #Протокол передачи UI-ивентов от ячейки коллекции и ее элементов
protocol RLCellEventDelegate: RLElementsCellDelegate, AnyObject {
    /// Ивент нажатия ячейку коллекции
    ///  - Parameters:
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didSelectItem(type: RLModelType, id: Int)
}

/// #Протокол передачи UI-ивентов от элементов ячейки
protocol RLElementsCellDelegate: RLFavoriteChangable, AnyObject {
    /// Ивент нажатия на кнопку добавления элементов
    ///  - Parameter id: идентификатор рецепта
    func didTapAddIngredientsButton(type: RLModelType, id: Int)
}

/// #Протокол изменения флага любимого рецепта
protocol RLFavoriteChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения флага любимого рецепта
    ///  - Parameters:
    ///   - isFavorite: флаг (верно/неверно)
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didTapFavoriteButton(_ isFavorite: Bool, type: RLModelType, id: Int)
}

/// #Протокол изменения `Layout` коллекции
protocol RLLayoutChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения `Layout`
    func didTapChangeLayoutButton()
}


/// Протокол делегата бизнес логики модуля RecipeList
protocol RecipeListBusinessLogicDelegate: AnyObject {
    
}

// MARK: - Presenter
/// #Слой презентации модуля RecipeList
final class RecipeListPresenter {
    
    private(set) var viewModels: [RLModelType: [RecipeModel]] = [:] {
        didSet {
            if isStart {
                guard let recommended = viewModels[.recommended],
                      let main = viewModels[.main] else { return }
                
                delegate?.updateUI(with: .main(first: recommended,
                                               second: main))
            } else {
                guard let main = viewModels[.main] else { return }
                delegate?.updateUI(with: .search(models: main))
            }
        }
    }
    private var isStart: Bool = false
    
    weak var delegate: RecipeListViewable?
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    func getStartData() {
        
//        interactor.fetchRandomRecipe(number: 4, tags: ["main course"]) { [weak self] result in
//            switch result {
//            case .success(let recipeCellModels):
//                self?.viewModels[.recommended] = recipeCellModels
//            case .failure(_):
//                break
//            }
//        }
//        
        let filterParameters = RecipeFilterParameters(cuisine: nil, diet: nil, type: "main course", intolerances: ["egg"], includeIngredients: ["meat"], excludeIngredients: [], maxCalories: nil, sort: nil)
        
        interactor.fetchRecipe(with: filterParameters, number: 6, query: nil) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):
                self?.viewModels[.main] = recipeCellModels
            case .failure(_):
                break
            }
        }
        
//        interactor.fetchRandomRecipe(number: 10, tags: ["salad"]) { [weak self] result in
//            switch result {
//            case .success(let recipeCellModels):
//                self?.viewModels[.main] = recipeCellModels
//            case .failure(_):
//                break
//            }
//        }
    }
}

// MARK: - Presentation
extension RecipeListPresenter: RecipeListPresentation {
    
    func fetchImage(with imageName: String,
               completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                self?.delegate?.showError()
            }
        }
    }
    
    func testTranslate() {
        interactor.translate(texts: ["Hello", "World"])
    }
    
    func testGetRandom() {
//        interactor.fetchRandomRecipe(number: 8, tags: ["main course"]) { [weak self] result in
//
//            switch result {
//            case .success(let recipeCellModels):
//                self?.delegate?.updateUI()
//            case .failure(_):
//                break
//            }
//        }
    }
    
    func testGetRecipe() {
        
        var parameters = RecipeFilterParameters()
        parameters.includeIngredients.append(contentsOf: ["onion", "cod"])
        parameters.sort = "random"
//        interactor.fetchRecipe(with: parameters, number: 3, query: nil)
    }
}

// MARK: - BusinessLogicDelegate
extension RecipeListPresenter: RecipeListBusinessLogicDelegate {
    
}


extension RecipeListPresenter {

    func didTapFavoriteButton(_ isFavorite: Bool,
        type: RLModelType, id: Int) {
        print("didTapFavoriteButton")
    }
    
    func didTapAddIngredientsButton(type: RLModelType, id: Int) {
        print("didTapAddIngredientsButton")
    }
    
    func didSelectItem(type: RLModelType, id: Int) {
        interactor.getModel(id: id) { [weak self] model in
            self?.router.route(to: .detailInfo, model: model)
        }
    }
    
    func didTapChangeLayoutButton() {
        print("didTapChangeLayoutButton")
        
        NotificationCenter.default
                    .post(name: NSNotification.Name("changeLayoutType"),
                     object: nil)
        
        delegate?.reloadSection(0)
    }
    
}
