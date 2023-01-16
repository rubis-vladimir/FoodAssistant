//
//  SpyFilterManager.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyFilterManager: FilterManagement {

    var parameters: [FilterParameters: [String]]

    init(parameters: [FilterParameters: [String]]) {
        self.parameters = parameters
    }

    func getRecipeParameters() -> [FilterParameters: [String]] {
        parameters
    }

    func overWrite(parameter: FilterParameters, value: [String]) {
        parameters[parameter] = value
    }
}
