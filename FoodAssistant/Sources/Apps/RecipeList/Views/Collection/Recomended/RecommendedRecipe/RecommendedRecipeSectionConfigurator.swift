//
//  RecommendedRecipeSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Конфигуратор секции RecommendedRecipe в коллекции
final class RecommendedRecipeSectionConfigurator {
    
    private let collectionView: UICollectionView
    private let models: [RecipeViewModel]
    
    weak var delegate: RecipeListPresentation?
    
    init(collectionView: UICollectionView,
         models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension RecommendedRecipeSectionConfigurator: CVSectionConfiguration {
    
    func configure() -> CVSectionBuilderProtocol {
        /// Конфигурируем и регистрируем ячейки
        let itemBuilder = RecommendedRecipeItemBuilder(models: models,
                                                       delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию без заголовка
        let mainSecionBuilder = CVSectionBuilder(headerBuilder: nil,
                                               itemBuilder: itemBuilder)
        return mainSecionBuilder
    }
}
