//
//  RLFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// #Варианты секций модуля RecipeList
enum RLSectionType {
    /// Рекомендованные
    case recommended
    /// Основные
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
    ///    - buildType: тип сборки
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         arrayModelsDictionary: [RecipeModelsDictionary],
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.arrayModelsDictionary = arrayModelsDictionary
        self.delegate = delegate
        
        cvAdapter = CVAdapter(collectionView: collectionView)
    }
    
    
    /// Настраивает представление коллекции
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        
        /// Обновление данных в коллекции
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(models: [RecipeViewModel],
                               type: RLSectionType) -> CVSectionBuilderProtocol {
        switch type {
        case .recommended:
            let configurator = RecommendedSectionConfigurator(models: models,
                                                              delegate: delegate)
            return SingleCellSectionConfigurator(title: "Рекомендации",
                                                 configurators: [configurator],
                                                 height: 360).configure(for: collectionView)
            
        case .main:
            return MainSectionConfigurator(models: models,
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
