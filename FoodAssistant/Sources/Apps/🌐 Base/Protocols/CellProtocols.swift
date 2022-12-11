//
//  CellProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//

import Foundation

typealias EventsCellDelegate = AddIngredientDelegate & FavoriteChangable

/// #Протокол передачи UI-ивентов от ячейки коллекции и ее элементов
protocol SelectedCellDelegate: AnyObject {
    /// Ивент нажатия ячейку коллекции
    ///  - Parameters:
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didSelectItem(id: Int)
}

/// #Протокол передачи UI-ивентов от элементов ячейки
protocol AddIngredientDelegate: AnyObject {
    /// Ивент нажатия на кнопку добавления элементов
    ///  - Parameter id: идентификатор рецепта
    func didTapAddIngredientsButton(id: Int)
}

/// #Протокол изменения флага любимого рецепта
protocol FavoriteChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения флага любимого рецепта
    ///  - Parameters:
    ///   - isFavorite: флаг (верно/неверно)
    ///   - type: тип модели
    ///   - id: идентификатор рецепта
    func didTapFavoriteButton(_ isFavorite: Bool, id: Int)
}

/// #Протокол изменения `Layout` коллекции
protocol LayoutChangable: AnyObject {
    /// Ивент нажатия на кнопку изменения `Layout`
    func didTapChangeLayoutButton(section: Int)
}
