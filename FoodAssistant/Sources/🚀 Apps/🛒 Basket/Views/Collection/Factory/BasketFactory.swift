//
//  BasketFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Варианты секций модуля Basket
enum BasketSectionType {
    /// Добавленные рецепты
    case addedRecipe
    /// Добавленные ингредиенты
    case shopList
}

/// #Фабрика настройки коллекции модуля Basket
final class BasketFactory {

    private let collectionView: UICollectionView
    private let recipes: [RecipeViewModel]
    private let ingredients: [IngredientViewModel]
    private let cvAdapter: CVAdapter

    private weak var delegate: BasketPresentation?

    /// Инициализатор
    ///  - Parameters:
    ///    - collectionView: настраиваемая коллекция
    ///    - recipes: рецепты
    ///    - ingredients: ингредиенты
    ///    - delegate: делегат для передачи UIEvent
    init(collectionView: UICollectionView,
         recipes: [RecipeViewModel],
         ingredients: [IngredientViewModel],
         delegate: BasketPresentation?) {
        self.collectionView = collectionView
        self.recipes = recipes
        self.ingredients = ingredients
        self.delegate = delegate

        /// Определяем адаптер для коллекции
        cvAdapter = CVAdapter()

        setupCollectionView()
    }

    /// Настраивает коллекцию
    private func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        cvAdapter.configure(with: builders)
    }

    /// Создает строителя ячеек
    ///  - Parameter type: тип секции
    ///  - Returns: объект протокола строителя
    private func createBuilder(type: BasketSectionType) -> CVSectionProtocol {
        switch type {
        case .addedRecipe:
            let configurator = AddedRecipesConfigurator(recipes: recipes,
                                                        delegate: delegate)
            return SingleCellSectionConfigurator(title: Constants.titleHeaderAddedRecipe,
                                                 configurators: [configurator],
                                                 height: Constants.heightSingleCell).configure(for: collectionView)
        case .shopList:

            return ShopListConfigurator(models: ingredients,
                                        title: Constants.titleHeaderShopList,
                                        heightCell: Constants.heightShopListCell,
                                        delegate: delegate).configure(for: collectionView)
        }
    }
}

// MARK: - TVFactoryProtocol
extension BasketFactory: CVFactoryProtocol {
    var builders: [CVSectionProtocol] {
        var builders: [CVSectionProtocol] = []

        builders.append(createBuilder(type: .addedRecipe))
        builders.append(createBuilder(type: .shopList))

        return builders
    }
}

// MARK: - Constants
extension BasketFactory {
    private struct Constants {
        static let titleHeaderAddedRecipe = "Added recipes".localize()
        static let heightSingleCell: CGFloat = 200

        static let titleHeaderShopList = "Shop-list".localize()
        static let heightShopListCell: CGFloat = 55
    }
}
