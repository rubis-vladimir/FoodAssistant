//
//  CDNutrient+CoreDataProperties.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//
//

import Foundation
import CoreData


extension CDNutrient: NutrientProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNutrient> {
        return NSFetchRequest<CDNutrient>(entityName: "CDNutrient")
    }

    @NSManaged public var amount: Float
    @NSManaged public var name: String
    @NSManaged public var unit: String
    @NSManaged public var recipe: CDRecipe?

}
