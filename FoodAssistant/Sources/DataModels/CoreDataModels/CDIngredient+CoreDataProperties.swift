//
//  CDIngredient+CoreDataProperties.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 12.12.2022.
//
//

import Foundation
import CoreData


extension CDIngredient: IngredientProtocol {
    var id: Int { Int(cdId) }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDIngredient> {
        return NSFetchRequest<CDIngredient>(entityName: "CDIngredient")
    }

    @NSManaged public var amount: Float
    @NSManaged public var cdId: Int32
    @NSManaged public var image: String?
    @NSManaged public var name: String
    @NSManaged public var unit: String?
    @NSManaged public var toUse: Bool
    @NSManaged public var inFridge: Bool
    @NSManaged public var recipe: CDRecipe?

}
