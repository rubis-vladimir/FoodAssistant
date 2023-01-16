//
//  MainSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Конфигуратор секции Main в коллекции
final class MainSectionConfigurator {
    /// Константы
    private struct Constants {
        static let firstImage = Icons.split2x2.image
        static let secondImage = Icons.split1x2.image
    }

    /// Вью модели рецептов
    private let models: [RecipeViewModel]
    /// Название заголовка
    private let titleHeader: String
    /// Высота ячейки
    private let height: CGFloat
    /// Действие при нажатии на кнопку в заголовке
    private let action: ((Int) -> Void)?

    private weak var delegate: RecipeListPresentation?

    init(models: [RecipeViewModel],
         titleHeader: String,
         height: CGFloat,
         action: ((Int) -> Void)?,
         delegate: RecipeListPresentation?) {
        self.models = models
        self.titleHeader = titleHeader
        self.height = height
        self.action = action
        self.delegate = delegate
    }
}

// MARK: - CVSectionConfiguration
extension MainSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: titleHeader,
                                             firstImage: Constants.firstImage,
                                             secondImage: Constants.secondImage,
                                             action: action)
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .withButton(headerModel: headerModel))
        headerBuilder.register(collectionView: collectionView)

        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = MainItemBuilder(models: models,
                                          height: height,
                                          delegate: delegate)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                               itemBuilder: itemBuilder)
        return secionBuilder
    }
}
