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
    private let recipes: [RecipeProtocol]
    private let ingredients: [IngredientViewModel]
    private let cvAdapter: CVAdapter
    
    private weak var delegate: BasketPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         recipes: [RecipeProtocol],
         ingredients: [IngredientViewModel],
         delegate: BasketPresentation?) {
        self.collectionView = collectionView
        self.recipes = recipes
        self.ingredients = ingredients
        self.delegate = delegate
        
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        setupCollectionView()
    }
    
    /// Настраивает табличное представление
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип секции
    ///   - Return: объект протокола строителя
    private func createBuilder(type: BasketSectionType) -> CVSectionBuilderProtocol {
        switch type {
        case .addedRecipe:
            let viewModels = recipes.map { RecipeViewModel(with: $0) }
            let configurator = AddedRecipesConfigurator(models: viewModels,
                                                        delegate: delegate)
            return SingleCellSectionConfigurator(title: "Добавленные рецепты",
                                                 configurators: [configurator],
                                                 height: 200).configure(for: collectionView)
        case .ingredients:
            
            return AddedIngredientsConfigurator(models: ingredients,
                                                title: "Шоп-лист",
                                                delegate: delegate).configure(for: collectionView)
        }
    }
}

//MARK: - TVFactoryProtocol
extension BasketFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        var builders: [CVSectionBuilderProtocol] = []
        
        builders.append(createBuilder(type: .addedRecipe))
        builders.append(createBuilder(type: .ingredients))
        
        return builders
    }
}


