//
//  CellProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//

import Foundation

/// #Протокол передачи UI-ивента при нажатии на ячейку
protocol SelectedCellDelegate: AnyObject {
    /// Ивент нажатия ячейку коллекции
    ///  - Parameters:
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didSelectItem(id: Int)
}

/// #Протокол передачи UI-ивента при нажатии на кнопку добавления в корзину
protocol InBasketAdded: AnyObject {
    /// Ивент нажатия на кнопку добавления элементов в корзину
    ///  - Parameter id: идентификатор рецепта
    func didTapAddInBasketButton(id: Int)
}

/// #Протокол изменения флага любимого рецепта
protocol FavoriteChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения флага любимого рецепта
    ///  - Parameters:
    ///   - isFavorite: флаг (верно/неверно)
    ///   - id: идентификатор рецепта
    func didTapFavoriteButton(_ isFavorite: Bool,
                              id: Int)
}

/// #Протокол изменения флага любимого рецепта
protocol RecipeRemovable: AnyObject {
    /// Ивент нажатия на кнопку удаления рецепта
    ///  - Parameters:
    ///   - id: идентификатор рецепта
    func didTapDeleteButton(id: Int)
}

/// #Варианты Layout
enum LayoutType {
    /// Две в ряду
    case split2xN
    /// Одна в ряду
    case split1xN
}

/// #Протокол изменения `Layout` секции коллекции
protocol LayoutChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения `Layout`
    ///  - Parameter section: номер секции
    func didTapChangeLayoutButton(section: Int)
}
