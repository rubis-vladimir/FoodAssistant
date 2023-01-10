//
//  MainSectionConfigurator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Конфигуратор секции Main в коллекции
final class MainSectionConfigurator {
    
    private struct Constants {
        static let firstImage = Icons.split2x2.image
        static let secondImage = Icons.split1x2.image
    }
    
    private let models: [RecipeViewModel]
    private let titleHeader: String
    
    private weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeViewModel],
         titleHeader: String,
         delegate: RecipeListPresentation?) {
        self.models = models
        self.titleHeader = titleHeader
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension MainSectionConfigurator: CVSectionConfiguration {
    
    func configure(for collectionView: UICollectionView) -> CVSectionProtocol {
        /// Создаем действие по изменению `Layout`
        let action: ((Int) -> Void)? = { section in self.delegate?.didTapChangeLayoutButton(section: section) }
        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: titleHeader,
                                             firstImage: Constants.firstImage,
                                             secondImage: Constants.secondImage,
                                             action: action )
        /// Конфигурируем билдер и регистрируем заголовок
        let headerBuilder = HeaderBuilder(type: .withButton(headerModel: headerModel))
        headerBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем билдер и регистрируем ячейки
        let itemBuilder = MainItemBuilder(models: models,
                                          delegate: delegate)
        itemBuilder.register(collectionView: collectionView)
        
        /// Конфигурируем секцию
        let secionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                               itemBuilder: itemBuilder)
        return secionBuilder
    }
}
