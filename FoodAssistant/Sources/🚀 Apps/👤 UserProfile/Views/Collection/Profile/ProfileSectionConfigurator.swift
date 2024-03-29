//
//  ProfileSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Конфигуратор секции Profile в коллекции
final class ProfileSectionConfigurator {
    /// Заголовок секции
    private let title: String
    /// Высота ячейки
    private let height: CGFloat

    init(title: String,
         height: CGFloat) {
        self.title = title
        self.height = height
    }
}

// MARK: - CVSectionConfiguration
extension ProfileSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: title))
        headerBuilder.register(collectionView: collectionView)

        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = ProfileItemBuilder(height: height)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: nil,
                                                 itemBuilder: itemBuilder)
        return secionBuilder
    }
}
