//
//  BasketFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Варианты секций модуля Basket
enum BasketSectionType {
    /// Добавленные рецепты
    case addedRecipe
    /// Добавленные ингредиенты
    case ingredients
}

/// #Фабрика настройки коллекции модуля Basket
final class BasketFactory {
    
    private let collectionView: UICollectionView
    private let recipes: [RecipeViewModel]
    private let ingredients: [IngredientViewModel]
    private let cvAdapter: CVAdapter
    
    private weak var delegate: BasketPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - collectionView: настраиваемая коллекция
    ///    - recipes: рецепты
    ///    - ingredients: ингредиенты
    ///    - delegate: делегат для передачи UIEvent
    init(collectionView: UICollectionView,
         recipes: [RecipeViewModel],
         ingredients: [IngredientViewModel],
         delegate: BasketPresentation?) {
        self.collectionView = collectionView
        self.recipes = recipes
        self.ingredients = ingredients
        self.delegate = delegate
        
        /// Определяем адаптер для коллекции
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        setupCollectionView()
    }
    
    /// Настраивает коллекцию
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameter type: тип секции
    ///   - Return: объект протокола строителя
    private func createBuilder(type: BasketSectionType) -> CVSectionBuilderProtocol {
        switch type {
        case .addedRecipe:
            let configurator = AddedRecipesConfigurator(recipes: recipes,
                                                        delegate: delegate)
            return SingleCellSectionConfigurator(title: Constants.titleAddedRecipeSection,
                                                 configurators: [configurator],
                                                 height: Constants.heightSingleCell ).configure(for: collectionView)
        case .ingredients:
            
            return AddedIngredientsConfigurator(models: ingredients,
                                                title: Constants.titleIngredientsSection,
                                                delegate: delegate).configure(for: collectionView)
        }
    }
}

// MARK: - TVFactoryProtocol
extension BasketFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        var builders: [CVSectionBuilderProtocol] = []
        
        builders.append(createBuilder(type: .addedRecipe))
        builders.append(createBuilder(type: .ingredients))
        
        return builders
    }
}

// MARK: - Constants
extension BasketFactory {
    private struct Constants {
        static let titleAddedRecipeSection = "Added recipes".localize()
        static let titleIngredientsSection = "Shop-list".localize()
        static let heightSingleCell: CGFloat = 200
    }
}


