//
//  FavoriteSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Конфигуратор секции Favorite в коллекции
final class FavoriteSectionConfigurator {
    /// Заголовок секции
    private let title: String
    /// Вью модели
    private let models: [RecipeViewModel]
    /// Высота ячейки
    private let height: CGFloat

    private weak var delegate: UserProfilePresentation?

    init(models: [RecipeViewModel],
         title: String,
         height: CGFloat,
         delegate: UserProfilePresentation?) {
        self.models = models
        self.title = title
        self.height = height
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
                                              height: height,
                                              delegate: delegate)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                             itemBuilder: itemBuilder)
        return secionBuilder
    }
}
