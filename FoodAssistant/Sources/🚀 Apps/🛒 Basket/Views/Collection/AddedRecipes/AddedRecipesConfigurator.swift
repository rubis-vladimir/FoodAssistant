//
//  AddedRecipesConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Конфигуратор секции AddedRecipes в коллекции
final class AddedRecipesConfigurator {
    /// Вью модели рецептов
    private let recipes: [RecipeViewModel]
    
    private weak var delegate: BasketPresentation?
    
    init(recipes: [RecipeViewModel],
         delegate: BasketPresentation?) {
        self.recipes = recipes
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension AddedRecipesConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = AddedRecipesItemBuilder(recipes: recipes,
                                                  delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: nil,
                                               itemBuilder: itemBuilder)
        return secionBuilder
    }
}
