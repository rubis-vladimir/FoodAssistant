//
//  SpyRecipeFilterInteractor.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeFilterInteractor: RecipeFilterBusinessLogic {

    var recipeParameters: RecipeFilterParameters
    var parameters: [FilterParameters: [TagModel]]
    var arrayIndexPath: [IndexPath]
    var text: String

     init(recipeParameters: RecipeFilterParameters,
          parameters: [FilterParameters: [TagModel]],
          arrayIndexPath: [IndexPath],
          text: String) {
         self.recipeParameters = recipeParameters
         self.parameters = parameters
         self.arrayIndexPath = arrayIndexPath
         self.text = text
     }

    func getParameters(completion: @escaping (RecipeFilterParameters) -> Void) {
        completion(recipeParameters)
    }

    func fetchFilterParameters(completion: @escaping ([FilterParameters: [TagModel]]) -> Void) {
        completion(parameters)
    }

    func fetchText(with parameter: FilterParameters,
                   completion: @escaping (String) -> Void) {
        completion(text)
    }

    func update(parameter: FilterParameters,
                text: String,
                completion: @escaping ([FilterParameters: [TagModel]]) -> Void) {
        parameters.removeValue(forKey: parameter)
        completion(parameters)
    }

    func checkFlag(indexPath: IndexPath) -> Bool {
        arrayIndexPath.contains(indexPath)
    }

    func changeFlag(_ flag: Bool,
                    indexPath: IndexPath) {
        arrayIndexPath.append(indexPath)
    }
}
