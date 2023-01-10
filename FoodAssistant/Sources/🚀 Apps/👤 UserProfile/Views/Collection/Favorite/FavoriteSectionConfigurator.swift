//
//  FavoriteSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Конфигуратор секции Favorite в коллекции
final class FavoriteSectionConfigurator {
    
    private let title = "Favorite Dishes".localize()
    
    private let models: [RecipeViewModel]
    
    private weak var delegate: UserProfilePresentation?
    
    init(models: [RecipeViewModel],
         delegate: UserProfilePresentation?) {
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension FavoriteSectionConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: title))
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = FavoriteItemBuilder(models: models,
                                              delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                             itemBuilder: itemBuilder)
        return secionBuilder
    }
}
