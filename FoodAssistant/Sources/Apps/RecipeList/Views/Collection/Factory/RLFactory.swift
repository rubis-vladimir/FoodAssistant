//
//  RLFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// #Типы сборок коллекции модуля RecipeList
enum RLBuildType {
    /// Основная при загрузке
    case main(first: [RecipeModel],
              second: [RecipeModel])
    /// При поиске рецептов
    case search(models: [RecipeModel])
}

/// #Фабрика настройки табличного представления модуля RecipeList
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
    private func createBuilder(models: [RecipeModel],
                               type: RLModelType) -> CVSectionBuilderProtocol {
        switch type {
        case .recommended:
            return RecommendedSectionConfigurator(collectionView: collectionView,
                                                  models: models,
                                                  delegate: delegate).configure()
        case .main:
            return MainSectionConfigurator(collectionView: collectionView,
                                           models: models,
                                           delegate: delegate).configure()
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
