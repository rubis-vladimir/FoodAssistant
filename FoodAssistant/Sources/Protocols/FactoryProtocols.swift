//
//  TVFactoryProtocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

// MARK: - Factory for TableView
/// Протокол фабрики для TableView
protocol TVFactoryProtocol {
    /// Строители ячеек
    var builders: [TVCBuilderProtocol] { get }
}

/// Протокол конструктора для создания и конфигурации ячейки
protocol TVCBuilderProtocol {
    /// Возвращает высоту ячейки
    func cellHeight() -> CGFloat
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                tableView: UITableView) -> UITableViewCell
}

// MARK: - Фабрика для CollectionView
/// #Протокол фабрики для коллекции
protocol CVFactoryProtocol {
    /// Строители ячеек
    var builders: [CVSectionBuilderProtocol] { get }
}

/// #Протокол конфигуратора Секции
protocol CVSectionConfiguration {
    /// Конфигурирует секцию
    func configure() -> CVSectionBuilderProtocol
}

/// #Протокол строителя секции коллекции
protocol CVSectionBuilderProtocol {
    /// Строитель заголовка
    var headerBuilder: CVHeaderBuilderProtocol? { get }
    /// Строитель ячеек
    var itemBuilder: CVItemBuilderProtocol { get }
    
    /// Инициализатор
    init(headerBuilder: CVHeaderBuilderProtocol?, itemBuilder: CVItemBuilderProtocol)
}

/// #Протокол строителя ячеек коллекции
protocol CVItemBuilderProtocol {
    /// Регистрирует ячейку в коллекции
    func register(collectionView: UICollectionView)
    /// Возвращает высоту ячейки
    func itemCount() -> Int
    /// Возвращает размеры ячейки
    func itemSize(collectionView: UICollectionView) -> CGSize
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell
    /// Ивент при нажатии на ячейку
    func didSelectItem(indexPath: IndexPath)
}

/// #Протокол строителя заголовка коллекции
protocol CVHeaderBuilderProtocol {
    /// Возвращает размеры заголовка
    func headerSize(collectionView: UICollectionView) -> CGSize
    /// Просматривает доп. элементы коллекции и возвращает их (заголовок)
    func viewSupplementaryElement(collectionView: UICollectionView,
                                  kind: String,
                                  indexPath: IndexPath) -> UICollectionReusableView
}


