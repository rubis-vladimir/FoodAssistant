//
//  RecommendedSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Конфигуратор секции Recommended в collectionView
final class RecommendedSectionConfigurator {
    /// Заголовок секции
    private let title: String = "Рекомендации"
    
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
extension RecommendedSectionConfigurator: CVSectionConfiguration {
    
    func configure() -> CVSectionBuilderProtocol {
        
        /// Конфигурируем и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: title))
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем и регистрируем ячейки
        let itemBuilder = RecommendedItemBuilder(models: models,
                                                 delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                           itemBuilder: itemBuilder)
        return secionBuilder
    }
}

