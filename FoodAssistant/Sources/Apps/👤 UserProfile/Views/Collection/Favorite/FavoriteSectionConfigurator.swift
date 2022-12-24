//
//  FavoriteSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Конфигуратор секции Main в коллекции
final class FavoriteSectionConfigurator {
    
    private struct Constants {
        static let title = "Любимые блюда"
        static let firstImage = Icons.split2x2.image
        static let secondImage = Icons.split1x2.image
    }
    
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
    
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol {
        /// Создаем действие по изменению `Layout`
        let action: ((Int) -> Void)? = { section in self.delegate?.didTapChangeLayoutButton(section: section) }
        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: Constants.title,
                                             firstImage: Constants.secondImage,
                                             secondImage: Constants.firstImage,
                                             action: action )
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .withButton(headerModel: headerModel))
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
