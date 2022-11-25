//
//  MainSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

// Конфигуратор секции Main в collectionView
final class MainSectionConfigurator {
    
    private let collectionView: UICollectionView
    private let models: [RecipeCellModel]
    private let layoutType: LayoutType
    private let title: String
    private var selector: Selector?
    
    weak var delegate: RecipeListPresentation?
    
    init(collectionView: UICollectionView,
         models: [RecipeCellModel],
         layoutType: LayoutType,
         title: String,
         selector: Selector?,
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.models = models
        self.layoutType = layoutType
        self.title = title
        self.selector = selector
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension MainSectionConfigurator: CVSectionConfiguration {
    
    
    func configure() -> CVSectionBuilderProtocol {
        
        /// Конфигурируем и регистрируем заголовок
        let headerBuilder = MainHeaderBuilder(title: title,
                                              selector: selector)
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем и регистрируем ячейки
        let itemBuilder = MainItemBuilder(models: models,
                                          layoutType: layoutType,
                                          delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let mainSecionBuilder = SectionBuilder(headerBuilder: headerBuilder,
                                               itemBuilder: itemBuilder)
        return mainSecionBuilder
    }
}
