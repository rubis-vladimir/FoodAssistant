//
//  FridgeSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

/// #Конфигуратор секции Fridge в коллекции
final class FridgeSectionConfigurator {
    /// Вью модели
    private let models: [IngredientViewModel]
    /// Заголовок секции
    private let title: String
    /// Высота ячейки
    private let height: CGFloat
    /// Изображение кнопки
    private let image: UIImage?
    /// Действие
    private let action: ((Int) -> Void)?

    private weak var delegate: UserProfilePresentation?

    init(models: [IngredientViewModel],
         title: String,
         height: CGFloat,
         image: UIImage?,
         action: ((Int) -> Void)?,
         delegate: UserProfilePresentation?) {
        self.models = models
        self.title = title
        self.image = image
        self.height = height
        self.action = action
        self.delegate = delegate
    }
}

// MARK: - CVSectionConfiguration
extension FridgeSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {

        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: title,
                                             firstImage: image,
                                             secondImage: nil,
                                             action: action)

        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .withButton(headerModel: headerModel))
        headerBuilder.register(collectionView: collectionView)

        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = FridgeItemBuilder(models: models,
                                            height: height,
                                            delegate: delegate)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                                 itemBuilder: itemBuilder)
        return secionBuilder
    }
}
