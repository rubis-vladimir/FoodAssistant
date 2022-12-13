//
//  CellProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//

import Foundation

typealias EventsCellDelegate = AddIngredientsDelegate & FavoriteChangable

/// #Протокол передачи UI-ивента при нажатии на ячейку
protocol SelectedCellDelegate: AnyObject {
    /// Ивент нажатия ячейку коллекции
    ///  - Parameters:
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didSelectItem(id: Int)
}

/// #Протокол передачи UI-ивента при нажатии на кнопку добавления ингредиентов
protocol AddIngredientsDelegate: AnyObject {
    /// Ивент нажатия на кнопку добавления элементов
    ///  - Parameter id: идентификатор рецепта
    func didTapAddIngredientsButton(id: Int)
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

/// #Протокол изменения `Layout` секции коллекции
protocol LayoutChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения `Layout`
    ///  - Parameter section: номер секции
    func didTapChangeLayoutButton(section: Int)
}
