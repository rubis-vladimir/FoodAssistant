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
        static let image = Icons.plusFill.image
    }
    
    private let models: [IngredientViewModel]
    
    private weak var delegate: UserProfilePresentation?
    
    init(models: [IngredientViewModel],
         delegate: UserProfilePresentation?) {
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension FridgeSectionConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol {
        
        /// Создаем действие по добавлению ингредиента
        let action: ((Int) -> Void)? = { _ in
            self.delegate?.didTapAddIngredientButton()
        }
        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: Constants.title,
                                             firstImage: Constants.image,
                                             secondImage: nil,
                                             action: action )
        
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .withButton(headerModel: headerModel))
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
