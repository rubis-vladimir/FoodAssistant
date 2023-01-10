//
//  TVSectionBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import Foundation

/// #Строитель секции для таблицы
final class TVSectionBuilder: TVSectionProtocol {
    var titleHeader: String?
    var cellBuilder: TVCellBuilderProtocol
    
    init(titleHeader: String?,
         cellBuilder: TVCellBuilderProtocol) {
        self.titleHeader = titleHeader
        self.cellBuilder = cellBuilder
    }
}
