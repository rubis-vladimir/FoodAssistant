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
        static let titleOne = "Популярные блюда"
        static let titleTwo = "Полученные рецепты"
        static let firstImage = Icons.split2x2.image
        static let secondImage = Icons.split1x2.image
    }
    
    private let collectionView: UICollectionView
    private let models: [RecipeModel]
    
    private weak var delegate: RecipeListPresentation?
    
    init(collectionView: UICollectionView,
         models: [RecipeModel],
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.models = models
        self.delegate = delegate
    }
}
    
// MARK: - CVSectionConfiguration
extension MainSectionConfigurator: CVSectionConfiguration {
    
    func configure() -> CVSectionBuilderProtocol {
        /// Создаем действие по изменению `Layout`
        let action: (() -> Void)? = { self.delegate?.didTapChangeLayoutButton() }
        /// Модель заголовка
        let headerModel = HeaderSectionModel(title: Constants.titleOne,
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
        let mainSecionBuilder = CVSectionBuilder(headerBuilder: headerBuilder,
                                               itemBuilder: itemBuilder)
        return mainSecionBuilder
    }
}
