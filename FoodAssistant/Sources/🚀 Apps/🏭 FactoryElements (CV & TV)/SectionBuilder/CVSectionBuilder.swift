//
//  MainSectionBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import Foundation

/// #Строитель для секции коллекции
final class CVSectionBuilder: CVSectionProtocol {
    var headerBuilder: CVHeaderBuilderProtocol?
    var itemBuilder: CVItemBuilderProtocol

    init(headerBuilder: CVHeaderBuilderProtocol?,
         itemBuilder: CVItemBuilderProtocol) {
        self.headerBuilder = headerBuilder
        self.itemBuilder = itemBuilder
    }
}
