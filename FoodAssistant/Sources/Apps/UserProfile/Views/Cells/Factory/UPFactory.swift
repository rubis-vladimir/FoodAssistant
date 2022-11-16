//
//  UserProfileFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

/// Типы текстовых ячеек модуля AddEvent
enum UPCellType {
    /// Ячейка для подгрузки фото
    case avatarCell
    /// Ячейка с заголовком события
    case shortAvatarCell
    
    case tabSetCell
    /// Ячейка с описанием события
    case detailCell
}

enum UPBuildType {
    case start
    case tagFridge
}

/// Действия при нажатии на кнопки
//enum AddEventActions {
//    /// Навигация
//    case route(_ type: AddEventTarget)
//    /// Сохраняем событие
//    case saveEvent
//    /// Изменяем событие
//    case changeEvent(_ type: AddEventChangeModelActions)
//}

/// Фабрика настройки табличного представления модуля AddEvent
final class UPFactory: NSObject {
    
    private let tableView: UITableView
    private weak var delegate: UserProfilePresentation?
    private let buildType: UPBuildType
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(tableView: UITableView,
         delegate: UserProfilePresentation?,
         buildType: UPBuildType) {
        
        self.tableView = tableView
        self.delegate = delegate
        self.buildType = buildType
        super.init()
        setupTableView()
    }
    
    /// Настраивает табличное представление
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(type: UPCellType) -> TVCBuilderProtocol {
        
        switch type {
        case .avatarCell:
            tableView.register(UPAvatarCell.self)
            return UPAvatarCellBuilder(delegate: delegate)
            
        case .shortAvatarCell:
            tableView.register(UPShortAvatarCell.self)
            return UPShortAvatarCellBuilder(delegate: delegate)
        case .tabSetCell:
            tableView.register(UPTabSetCell.self)
            return UPTabSetCellBuilder(delegate: delegate)
        case .detailCell:
            return UPAvatarCellBuilder(delegate: delegate)
        }
    }
}

//MARK: - TVFactoryProtocol
extension UPFactory: TVFactoryProtocol {
    
    var builders: [TVCBuilderProtocol] {
        var builders: [TVCBuilderProtocol] = []
        
        switch buildType {
        case .start:
            builders.append(contentsOf: [createBuilder(type: .avatarCell),
                                         createBuilder(type: .tabSetCell)])
        case .tagFridge:
            builders.append(contentsOf: [createBuilder(type: .shortAvatarCell),
                                         createBuilder(type: .tabSetCell),
                                         createBuilder(type: .avatarCell)])
        }
        
        return builders
    }
}

extension UPFactory: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        builders.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return builders[indexPath.row].cellAt(indexPath: indexPath, tableView: tableView)
    }
}

extension UPFactory: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return builders[indexPath.row].cellHeight()
    }
}
