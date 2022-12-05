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
protocol RecipeListPresentation: LayoutChangable, RLCellEventDelegate, AnyObject {
    /// Вью модели
    var viewModels: [RLModelType: [RecipeModel]] { get }
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
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
protocol RLElementsCellDelegate: FavoriteChangable, AnyObject {
    /// Ивент нажатия на кнопку добавления элементов
    ///  - Parameter id: идентификатор рецепта
    func didTapAddIngredientsButton(type: RLModelType, id: Int)
}

/// #Протокол изменения флага любимого рецепта
protocol FavoriteChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения флага любимого рецепта
    ///  - Parameters:
    ///   - isFavorite: флаг (верно/неверно)
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didTapFavoriteButton(_ isFavorite: Bool, type: RLModelType, id: Int)
}

/// #Протокол изменения `Layout` коллекции
protocol LayoutChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения `Layout`
    func didTapChangeLayoutButton(section: Int)
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
    /// Флаг варианта загрузки данных коллекции
    private var isStart: Bool = false
    
    weak var delegate: RecipeListViewable?
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    /// Загрузка данных при начальной загрузке приложения
    func getStartData() {
        let filterParameters = RecipeFilterParameters(cuisine: nil, diet: nil, type: "main course", intolerances: ["egg"], includeIngredients: ["meat"], excludeIngredients: [], maxCalories: nil, sort: nil)
        
        interactor.fetchRecipe(with: filterParameters, number: 3, query: nil) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):
                self?.viewModels[.main] = recipeCellModels
            case .failure(_):
                break
            }
        }
        
        // Доп запрос
        //        interactor.fetchRandomRecipe(number: 4, tags: ["main course"]) { [weak self] result in
        //            switch result {
        //            case .success(let recipeCellModels):
        //                self?.viewModels[.recommended] = recipeCellModels
        //            case .failure(_):
        //                break
        //            }
        //        }
        //
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
    
    func didTapChangeLayoutButton(section: Int) {
        NotificationCenter.default
                    .post(name: NSNotification.Name("changeLayoutType"),
                     object: nil)
        
        delegate?.reloadSection(section)
    }
}
