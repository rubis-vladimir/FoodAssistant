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

/// #Варианты сборок коллекции модуля RecipeList
enum RLBuildType {
    /// Основная при загрузке
    case main(first: [RecipeViewModel],
              second: [RecipeViewModel])
    /// При поиске рецептов
    case search(models: [RecipeViewModel])
}

/// #Фабрика настройки коллекции модуля RecipeList
final class RLFactory {
    
    private let collectionView: UICollectionView
    private let buildType: RLBuildType
    private var cvAdapter: CVAdapter
    
    private weak var delegate: RecipeListPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - buildType: тип сборки
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         buildType: RLBuildType,
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.buildType = buildType
        self.delegate = delegate
        
        cvAdapter = CVAdapter(collectionView: collectionView)
    }
    
    /// Настраивает табличное представление
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
                                                 height: 320).configure(for: collectionView)
            
        case .main:
            return MainSectionConfigurator(models: models,
                                           delegate: delegate).configure(for: collectionView)
        }
    }
}

//MARK: - TVFactoryProtocol
extension RLFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        var builders: [CVSectionBuilderProtocol] = []
        
        switch buildType {
        case let .main(first, second):
            builders.append(contentsOf: [
                createBuilder(models: first, type: .recommended),
                createBuilder(models: second, type: .main)
            ])
            
        case .search(let models):
            builders.append(contentsOf: [
                createBuilder(models: models, type: .main)
            ])
        }
        return builders
    }
}
