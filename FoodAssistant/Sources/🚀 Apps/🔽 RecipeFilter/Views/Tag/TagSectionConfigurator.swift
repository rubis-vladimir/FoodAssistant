//
//  TagSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

/// #Конфигуратор для Tag-секции
final class TagSectionConfigurator {
    
    private let header: HeaderType?
    private let tagModels: [TagModel]
    
    private weak var delegate: RecipeFilterPresentation?
    
    init(header: HeaderType?,
         tagModels: [TagModel],
         delegate: RecipeFilterPresentation?) {
        self.header = header
        self.tagModels = tagModels
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension TagSectionConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        
        var headerBuilder: CVHeaderBuilderProtocol?
        
        if let header = header {
            /// Конфигурируем билдер и регистрируем заголовок
            headerBuilder = HeaderBuilder(type: header)
            headerBuilder?.register(collectionView: collectionView)
        }
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = TagCellBuilder(tagModels: tagModels,
                                         delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                               itemBuilder: itemBuilder)
        return secionBuilder
    }
}

