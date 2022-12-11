//
//  AddedRecipesConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Конфигуратор секции Main в коллекции
final class AddedRecipesConfigurator {
    
    private let models: [RecipeViewModel]
    
    private weak var delegate: BasketPresentation?
    
    init(models: [RecipeViewModel],
         delegate: BasketPresentation?) {
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension AddedRecipesConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol {
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = AddedRecipesItemBuilder(models: models,
                                                  delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let mainSecionBuilder = CVSectionBuilder(headerBuilder: nil,
                                               itemBuilder: itemBuilder)
        return mainSecionBuilder
    }
}
