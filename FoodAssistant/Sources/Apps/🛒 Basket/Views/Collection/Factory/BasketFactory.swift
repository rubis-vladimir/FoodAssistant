//
//  BasketFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

enum BasketModelType {
    case addedRecipe
    case ingredients
}


/// #Фабрика настройки табличного представления модуля AddEvent
final class BasketFactory: NSObject {
    
    private let collectionView: UICollectionView
    private let models: [RecipeProtocol]
    private let cvAdapter: CVAdapter
    
    private weak var delegate: BasketPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         models: [RecipeProtocol],
         delegate: BasketPresentation?) {
        self.collectionView = collectionView
        self.models = models
        self.delegate = delegate
        
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        super.init()
        setupCollectionView()
    }
    
    /// Настраивает табличное представление
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.backgroundColor = .clear
        
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(type: BasketModelType) -> CVSectionBuilderProtocol {
        
        
        switch type {
        case .addedRecipe:
            let viewModels = models.map { RecipeViewModel(with: $0) }
            let configurator = AddedRecipesConfigurator(models: viewModels,
                                                        delegate: delegate)
            return SingleCellSectionConfigurator(title: "Добавленные рецепты",
                                                 configurators: [configurator],
                                                 height: 200).configure(for: collectionView)
        case .ingredients:
            let viewModels = models.map { RecipeViewModel(with: $0) }
            let configurator = AddedRecipesConfigurator(models: viewModels,
                                                        delegate: delegate)
            return SingleCellSectionConfigurator(title: nil,
                                                 configurators: [configurator],
                                                 height: 200).configure(for: collectionView)
        }
        
    }
}

//MARK: - TVFactoryProtocol
extension BasketFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        var builders: [CVSectionBuilderProtocol] = []
        
        builders.append(createBuilder(type: .addedRecipe))
        
        return builders
    }
}


