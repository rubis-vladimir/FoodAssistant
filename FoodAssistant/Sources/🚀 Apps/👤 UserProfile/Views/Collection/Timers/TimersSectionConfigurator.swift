//
//  TimersSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.01.2023.
//

import UIKit

/// #Конфигуратор секции Profile в коллекции
final class TimersSectionConfigurator {
    /// Заголовок секции
    private let title: String
    /// Высота ячейки
    private let height: CGFloat
    /// Таймеры
    private let timers: [RecipeTimer]

    init(title: String,
         timers: [RecipeTimer],
         height: CGFloat) {
        self.title = title
        self.timers = timers
        self.height = height
    }
}

// MARK: - CVSectionConfiguration
extension TimersSectionConfigurator: CVSectionConfiguration {

    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: title))
        headerBuilder.register(collectionView: collectionView)

        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = TimersItemBuilder(height: height,
                                            timers: timers)
        itemBuilder.register(collectionView: collectionView)

        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                             itemBuilder: itemBuilder)
        return secionBuilder
    }
}
