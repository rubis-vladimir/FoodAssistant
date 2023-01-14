//
//  UserProfileFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

/// #Типы секций модуля UserProfile
enum UPSectionType {
    /// Секция профиля
    case profile
    /// Секция холодильника
    case fridge(_ ingredients: [IngredientViewModel])
    /// Секция с избранными рецептами
    case favorite(_ recipes: [RecipeViewModel])
    /// Секция с таймерами
    case timers(_ timers: [RecipeTimer])
}

/// #Фабрика настройки представления коллекции модуля UserProfile
final class UPFactory {
    
    private let collectionView: UICollectionView
    private let orderSections: [UPSectionType]
    private let cvAdapter: CVAdapter
    
    private weak var delegate: UserProfilePresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - collectionView: настраиваемая коллекция
    ///    - delegate: делегат для передачи UIEvent
    ///    - orderSections: массив секций по порядку
    init(collectionView: UICollectionView,
         delegate: UserProfilePresentation?,
         orderSections: [UPSectionType]) {
        
        self.collectionView = collectionView
        self.delegate = delegate
        self.orderSections = orderSections
        
        /// Определяем адаптер для коллекции
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        setupCollectionView()
    }
    
    /// Настраивает  коллекцию
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameter type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(type: UPSectionType) -> CVSectionProtocol {
        
        switch type {
        case .profile: 
            return ProfileSectionConfigurator(title: Constants.titleHeaderProfile,
                                              height: Constants.heightProfileCell).configure(for: collectionView)
            
        case .fridge(let ingredients):
            return FridgeSectionConfigurator(models: ingredients,
                                             title: Constants.titleHeaderFridge,
                                             height: Constants.heightFridgeCell,
                                             image: Constants.imageHeaderButton,
                                             delegate: delegate).configure(for: collectionView)
        case .favorite(let models):
            return FavoriteSectionConfigurator(models: models,
                                               title: Constants.titleHeaderFavorite, height: Constants.heightFavoriteCell,
                                               delegate: delegate).configure(for: collectionView)
        case .timers(let timers):
            return FavoriteSectionConfigurator(models: [],
                                               title: Constants.titleHeaderFavorite,
                                               delegate: delegate).configure(for: collectionView)

        }
        
    }
}

//MARK: - TVFactoryProtocol
extension UPFactory: CVFactoryProtocol {
    
    var builders: [CVSectionProtocol] {
        orderSections.map { createBuilder(type: $0) }
    }
}

// MARK: - Constants
extension UPFactory {
    private struct Constants {
        static let titleHeaderProfile = "My data".localize()
        static let heightProfileCell: CGFloat = 250
        
        static let titleHeaderFridge = "In my fridge".localize()
        static let imageHeaderButton = Icons.plusFill.image
        static let heightFridgeCell: CGFloat = 55
        
        static let titleHeaderFavorite = "Favorite Dishes".localize()
        static let heightFavoriteCell: CGFloat = 125
    }
}

