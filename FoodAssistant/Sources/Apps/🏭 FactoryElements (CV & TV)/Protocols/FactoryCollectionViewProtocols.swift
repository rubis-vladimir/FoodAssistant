//
//  FactoryCollectionViewProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// MARK: - Фабрика для CollectionView
/// #Протокол фабрики для коллекции
protocol CVFactoryProtocol {
    /// Строители ячеек
    var builders: [CVSectionBuilderProtocol] { get }
}

/// #Протокол конфигуратора Секции
protocol CVSectionConfiguration {
    /// Конфигурирует секцию
    func configure(for collectionView: UICollectionView) -> CVSectionBuilderProtocol
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
    func itemSize(indexPath: IndexPath,
                  collectionView: UICollectionView) -> CGSize
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell
}

/// #Протокол строителя для обработки нажатия на ячейку
protocol CVSelectableItemBuilderProtocol: CVItemBuilderProtocol {
    /// Ивент при нажатии на ячейку
    func didSelectItem(indexPath: IndexPath)
}

/// #Протокол строителя заголовка коллекции
protocol CVHeaderBuilderProtocol {
    /// Регистрирует заголовок 
    func register(collectionView: UICollectionView)
    /// Возвращает размеры заголовка
    func headerSize(collectionView: UICollectionView) -> CGSize
    /// Просматривает доп. элементы коллекции и возвращает их (заголовок)
    func viewSupplementaryElement(collectionView: UICollectionView,
                                  kind: String,
                                  indexPath: IndexPath) -> UICollectionReusableView
}


