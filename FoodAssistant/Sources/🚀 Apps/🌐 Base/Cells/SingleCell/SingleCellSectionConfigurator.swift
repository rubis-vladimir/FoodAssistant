//
//  SingleCellSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Конфигуратор секции единичной ячейки с коллекцией
final class SingleCellSectionConfigurator {

    private let title: String?
    private let configurators: [CVSectionConfiguration]
    private let height: CGFloat

    init(title: String?,
         configurators: [CVSectionConfiguration],
         height: CGFloat) {
        self.title = title
        self.configurators = configurators
        self.height = height
    }
}

// MARK: - CVSectionConfiguration
extension SingleCellSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Конфигурируем стандартный заголовок секции
        var headerBuilder: HeaderBuilder?
        if let title = title {
            headerBuilder = HeaderBuilder(type: .base(title: title))
            headerBuilder?.register(collectionView: collectionView)
        }

        /// Конфигурируем билдер и регистрируем ячейку
        let itemBuilder = SingleCellBuilder(height: height,
                                            configurators: configurators)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                             itemBuilder: itemBuilder)
        return secionBuilder
    }
}
