//
//  RecommendedSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Конфигуратор секции Recommended в коллекции
final class RecommendedSectionConfigurator {
    /// Вью модели рецептов
    private let models: [RecipeViewModel]

    weak var delegate: RecipeListPresentation?

    init(models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
    }
}

// MARK: - CVSectionConfiguration
extension RecommendedSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Конфигурируем и регистрируем ячейки
        let itemBuilder = RecommendedItemBuilder(models: models,
                                                       delegate: delegate)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию без заголовка
        let secionBuilder = CVSectionBuilder(headerBuilder: nil,
                                               itemBuilder: itemBuilder)
        return secionBuilder
    }
}
