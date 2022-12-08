//
//  CDRecipe+CoreDataProperties.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//
//

import Foundation
import CoreData


extension CDRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRecipe> {
        return NSFetchRequest<CDRecipe>(entityName: "CDRecipe")
    }

    @NSManaged public var cookingTime: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageName: String?
    @NSManaged public var servings: Int16
    @NSManaged public var title: String?
    @NSManaged public var ingredients: [CDIngredient]?
    @NSManaged public var instructionSteps: NSSet?
    @NSManaged public var nutrients: NSSet?

}

// MARK: Generated accessors for ingredients
extension CDRecipe {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: CDIngredient, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [CDIngredient], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: CDIngredient)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [CDIngredient])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: CDIngredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: CDIngredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSOrderedSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for instructionSteps
extension CDRecipe {

    @objc(addInstructionStepsObject:)
    @NSManaged public func addToInstructionSteps(_ value: CDInstrutionStep)

    @objc(removeInstructionStepsObject:)
    @NSManaged public func removeFromInstructionSteps(_ value: CDInstrutionStep)

    @objc(addInstructionSteps:)
    @NSManaged public func addToInstructionSteps(_ values: NSSet)

    @objc(removeInstructionSteps:)
    @NSManaged public func removeFromInstructionSteps(_ values: NSSet)

}

// MARK: Generated accessors for nutrients
extension CDRecipe {

    @objc(addNutrientsObject:)
    @NSManaged public func addToNutrients(_ value: CDNutrient)

    @objc(removeNutrientsObject:)
    @NSManaged public func removeFromNutrients(_ value: CDNutrient)

    @objc(addNutrients:)
    @NSManaged public func addToNutrients(_ values: NSSet)

    @objc(removeNutrients:)
    @NSManaged public func removeFromNutrients(_ values: NSSet)

}
