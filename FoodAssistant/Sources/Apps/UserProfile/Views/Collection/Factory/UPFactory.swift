//
//  UserProfileFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

/// Типы текстовых ячеек модуля AddEvent
enum UPModelType {
    /// Ячейка для подгрузки фото
//    case profile
//
    case fridge(_ ingredients: [IngredientProtocol])
    /// Ячейка с описанием события
    case favorite(_ recipes: [RecipeViewModel])
}

enum UPBuildType {
//    case profile
    case fridge(_ ingredients: [IngredientProtocol])
    case favorite(_ recipes: [RecipeViewModel])
}


/// Фабрика настройки табличного представления модуля AddEvent
final class UPFactory: NSObject {
    
    private let collectionView: UICollectionView
    private let buildType: UPBuildType
    private let cvAdapter: CVAdapter
    
    private weak var delegate: UserProfilePresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         delegate: UserProfilePresentation?,
         buildType: UPBuildType) {
        
        self.collectionView = collectionView
        self.delegate = delegate
        self.buildType = buildType
        
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
    private func createBuilder(type: UPModelType) -> CVSectionBuilderProtocol {
    
        
        switch type {
        case .favorite(let models):
            return FavoriteSectionConfigurator(collectionView: collectionView,
                                               models: models,
                                               delegate: delegate).configure()
        case .fridge(let ingredients):
            return FridgeSectionConfigurator(collectionView: collectionView,
                                             models: ingredients,
                                             delegate: delegate).configure()
        }
        
    }
}

//MARK: - TVFactoryProtocol
extension UPFactory: CVFactoryProtocol {
    
    var builders: [CVSectionBuilderProtocol] {
        var builders: [CVSectionBuilderProtocol] = []
        
        switch buildType {
            
        case .favorite(let recipes):
            builders.append(contentsOf: [
                createBuilder(type: .favorite(recipes))
            ])
        case .fridge(let ingredients):
            builders.append(contentsOf: [
                createBuilder(type: .fridge(ingredients))
            ])
        }
        
        
        return builders
    }
}

