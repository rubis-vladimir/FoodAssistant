//
//  RecommendedSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

// Конфигуратор секции Recommended в collectionView
final class RecommendedSectionConfigurator {
    
    private let collectionView: UICollectionView
    private let models: [RecipeCellModel]
    private let title: String
    private var isSelector: Bool
    
    weak var delegate: RecipeListPresentation?
    
    init(collectionView: UICollectionView,
         models: [RecipeCellModel],
         title: String,
         isSelector: Bool,
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.models = models
        self.title = title
        self.isSelector = isSelector
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension RecommendedSectionConfigurator: CVSectionConfiguration {
    
    func configure() -> CVSectionBuilderProtocol {
        
        /// Конфигурируем и регистрируем заголовок
        let headerBuilder = MainHeaderBuilder(title: title,
                                              isSelector: isSelector,
                                              delegate: delegate!)
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

