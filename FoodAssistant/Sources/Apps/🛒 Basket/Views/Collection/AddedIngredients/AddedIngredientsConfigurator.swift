//
//  AddedIngredientsConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.12.2022.
//

import UIKit

/// #Конфигуратор секции AddedRecipes в коллекции
final class AddedIngredientsConfigurator {
    
    private let models: [IngredientProtocol]
    private let title: String
    
    private weak var delegate: BasketPresentation?
    
    init(models: [IngredientProtocol],
         title: String,
         delegate: BasketPresentation?) {
        self.models = models
        self.title = title
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension AddedIngredientsConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol {
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = AddedIngredientsItemBuilder(models: models,
                                                      delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: title))
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                                 itemBuilder: itemBuilder)
        return secionBuilder
    }
}
