//
//  RLFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// Типы текстовых ячеек модуля AddEvent
enum RLCellType {
    
    case recommendedViewCell
    
    case mainCell
    
    case fullMainCell
}

enum RLBuildType {
    case main(first: [RecipeCellModel],
              second: [RecipeCellModel])
    case search(models: [RecipeCellModel])
}

/// Фабрика настройки табличного представления модуля AddEvent
final class RLFactory {
    
    private let collectionView: UICollectionView
    private let buildType: RLBuildType
    private var recipeListAdapter: RLAdapter
    
    private weak var delegate: RecipeListPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         buildType: RLBuildType,
         delegate: RecipeListPresentation?) {
        self.collectionView = collectionView
        self.buildType = buildType
        self.delegate = delegate
        
        recipeListAdapter = RLAdapter(collectionView: collectionView)
    }
    
    /// Настраивает табличное представление
    func setupCollectionView() {
        collectionView.dataSource = recipeListAdapter
        collectionView.delegate = recipeListAdapter
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CustomSectionHeader.self, kind: UICollectionView.elementKindSectionHeader)
        
        recipeListAdapter.builders = builders
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(models: [RecipeCellModel],
                               type: RLCellType) -> CVSectionBuilderProtocol {
        switch type {
        case .recommendedViewCell:
            return RecommendedSectionConfigurator(collectionView: collectionView,
                                                  models: models,
                                                  title: "Рекомендации",
                                                  selector: nil,
                                                  delegate: delegate).configure()
        case .mainCell:
            return MainSectionConfigurator(collectionView: collectionView,
                                           models: models,
                                           layoutType: .split2xN,
                                           title: "Популярные блюда",
                                           selector: nil,
                                           delegate: delegate).configure()
        case .fullMainCell:
            return MainSectionConfigurator(collectionView: collectionView,
                                           models: models,
                                           layoutType: .split2xN,
                                           title: "Рекомендации",
                                           selector: nil,
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
                createBuilder(models: first, type: .recommendedViewCell),
                createBuilder(models: second, type: .mainCell)
            ])
            print("CVCBuilderProtocol - \(builders)")
        case .search(let models):
            builders.append(contentsOf: [
                createBuilder(models: models, type: .fullMainCell)
            ])
        }
        return builders
    }
}
