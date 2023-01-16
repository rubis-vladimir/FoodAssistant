//
//  ShopListConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.12.2022.
//

import UIKit

/// #Конфигуратор секции AddedRecipes в коллекции
final class ShopListConfigurator {
    /// Вью модели ингредиентов
    private let models: [IngredientViewModel]
    /// Заголовок секции
    private let title: String
    /// Высота ячейки
    private let heightCell: CGFloat

    private weak var delegate: BasketPresentation?

    init(models: [IngredientViewModel],
         title: String,
         heightCell: CGFloat,
         delegate: BasketPresentation?) {
        self.models = models
        self.title = title
        self.heightCell = heightCell
        self.delegate = delegate
    }
}

// MARK: - CVSectionConfiguration
extension ShopListConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {

        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = ShopListItemBuilder(models: models,
                                              height: heightCell,
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
