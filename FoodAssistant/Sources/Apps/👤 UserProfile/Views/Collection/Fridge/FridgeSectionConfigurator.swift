//
//  FridgeSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

/// #Конфигуратор секции Main в коллекции
final class FridgeSectionConfigurator {
    
    private struct Constants {
        static let title = "В моем холодильнике"
    }
    
    private let models: [IngredientProtocol]
    
    private weak var delegate: UserProfilePresentation?
    
    init(models: [IngredientProtocol],
         delegate: UserProfilePresentation?) {
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension FridgeSectionConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol {
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .base(title: Constants.title))
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = FridgeItemBuilder(models: models,
                                            delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                                 itemBuilder: itemBuilder)
        return secionBuilder
    }
}
