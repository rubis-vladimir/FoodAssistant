//
//  RLFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// #Варианты секций модуля RecipeList
enum RLSectionType {
    /// Рекомендации
    case recommended
    /// Основная
    case main
}

/// #Фабрика настройки коллекции модуля RecipeList
final class RLFactory {
    
    private let collectionView: UICollectionView
    private let arrayModelsDictionary: [RecipeModelsDictionary]
    private var cvAdapter: CVAdapter
    
    private weak var delegate: RecipeListPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - collectionView: настраиваемая коллекция
    ///    - arrayModelsDictionary: массив моделей словарей
    ///    - delegate: делегат для передачи UIEvent
    init(collectionView: UICollectionView,
         arrayModelsDictionary: [RecipeModelsDictionary],
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.arrayModelsDictionary = arrayModelsDictionary
        self.delegate = delegate
        
        /// Определяем адаптер для коллекции
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        setupCollectionView()
    }
    
    
    /// Настраивает представление коллекции
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        /// Обновление данных в коллекции
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - models: модели рецептов
    ///     - type: тип секции
    ///   - Return: объект протокола строителя
    private func createBuilder(models: [RecipeViewModel],
                               type: RLSectionType) -> CVSectionBuilderProtocol {
        switch type {
        case .recommended:
            let configurator = RecommendedSectionConfigurator(models: models,
                                                              delegate: delegate)
            return SingleCellSectionConfigurator(title: Constants.recommendedTitle,
                                                 configurators: [configurator],
                                                 height: Constants.reccomendedHeight).configure(for: collectionView)
            
        case .main:
            return MainSectionConfigurator(models: models,
                                           titleHeader: Constants.mainTitle,
                                           delegate: delegate).configure(for: collectionView)
        }
    }
}

//MARK: - TVFactoryProtocol
extension RLFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        arrayModelsDictionary.flatMap {
            $0.map { createBuilder(models: $0.value, type: $0.key) }
        }
    }
}

// MARK: - Constants
extension RLFactory {
    private struct Constants {
        static let recommendedTitle = "Recommendations".localize()
        static let mainTitle = "Base Recipes".localize()
        static let reccomendedHeight: CGFloat = 360
    }
}
