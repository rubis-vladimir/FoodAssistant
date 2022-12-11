//
//  CDRecipe+CoreDataProperties.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//
//

import Foundation
import CoreData


extension CDRecipe: RecipeProtocol {
    var inBasket: Bool {
        false
    }
    
    var isFavorite: Bool { true }
    
    var id: Int { Int(cdId) }
    var servings: Int { Int(cdServings) }

    var ingredients: [IngredientProtocol]? {
        return cdIngredients
    }
    
    var nutrients: [NutrientProtocol]? {
        return cdNutrients
    }
    
    var instructions: [InstructionStepProtocol]? {
        return cdInstructionSteps
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRecipe> {
        return NSFetchRequest<CDRecipe>(entityName: "CDRecipe")
    }

    @NSManaged public var cookingTime: String
    @NSManaged public var cdId: Int32
    @NSManaged public var imageName: String?
    @NSManaged public var cdServings: Int16
    @NSManaged public var title: String
    @NSManaged public var cdIngredients: [CDIngredient]?
    @NSManaged public var cdInstructionSteps: [CDInstrutionStep]?
    @NSManaged public var cdNutrients: [CDNutrient]?

}

// MARK: Generated accessors for cdIngredients
extension CDRecipe {

    @objc(insertObject:inCdIngredientsAtIndex:)
    @NSManaged public func insertIntoCdIngredients(_ value: CDIngredient, at idx: Int)

    @objc(removeObjectFromCdIngredientsAtIndex:)
    @NSManaged public func removeFromCdIngredients(at idx: Int)

    @objc(insertCdIngredients:atIndexes:)
    @NSManaged public func insertIntoCdIngredients(_ values: [CDIngredient], at indexes: NSIndexSet)

    @objc(removeCdIngredientsAtIndexes:)
    @NSManaged public func removeFromCdIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInCdIngredientsAtIndex:withObject:)
    @NSManaged public func replaceCdIngredients(at idx: Int, with value: CDIngredient)

    @objc(replaceCdIngredientsAtIndexes:withCdIngredients:)
    @NSManaged public func replaceCdIngredients(at indexes: NSIndexSet, with values: [CDIngredient])

    @objc(addCdIngredientsObject:)
    @NSManaged public func addToCdIngredients(_ value: CDIngredient)

    @objc(removeCdIngredientsObject:)
    @NSManaged public func removeFromCdIngredients(_ value: CDIngredient)

    @objc(addCdIngredients:)
    @NSManaged public func addToCdIngredients(_ values: NSOrderedSet)

    @objc(removeCdIngredients:)
    @NSManaged public func removeFromCdIngredients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for cdInstructionSteps
extension CDRecipe {

    @objc(insertObject:inCdInstructionStepsAtIndex:)
    @NSManaged public func insertIntoCdInstructionSteps(_ value: CDInstrutionStep, at idx: Int)

    @objc(removeObjectFromCdInstructionStepsAtIndex:)
    @NSManaged public func removeFromCdInstructionSteps(at idx: Int)

    @objc(insertCdInstructionSteps:atIndexes:)
    @NSManaged public func insertIntoCdInstructionSteps(_ values: [CDInstrutionStep], at indexes: NSIndexSet)

    @objc(removeCdInstructionStepsAtIndexes:)
    @NSManaged public func removeFromCdInstructionSteps(at indexes: NSIndexSet)

    @objc(replaceObjectInCdInstructionStepsAtIndex:withObject:)
    @NSManaged public func replaceCdInstructionSteps(at idx: Int, with value: CDInstrutionStep)

    @objc(replaceCdInstructionStepsAtIndexes:withCdInstructionSteps:)
    @NSManaged public func replaceCdInstructionSteps(at indexes: NSIndexSet, with values: [CDInstrutionStep])

    @objc(addCdInstructionStepsObject:)
    @NSManaged public func addToCdInstructionSteps(_ value: CDInstrutionStep)

    @objc(removeCdInstructionStepsObject:)
    @NSManaged public func removeFromCdInstructionSteps(_ value: CDInstrutionStep)

    @objc(addCdInstructionSteps:)
    @NSManaged public func addToCdInstructionSteps(_ values: NSOrderedSet)

    @objc(removeCdInstructionSteps:)
    @NSManaged public func removeFromCdInstructionSteps(_ values: NSOrderedSet)

}

// MARK: Generated accessors for cdNutrients
extension CDRecipe {

    @objc(insertObject:inCdNutrientsAtIndex:)
    @NSManaged public func insertIntoCdNutrients(_ value: CDNutrient, at idx: Int)

    @objc(removeObjectFromCdNutrientsAtIndex:)
    @NSManaged public func removeFromCdNutrients(at idx: Int)

    @objc(insertCdNutrients:atIndexes:)
    @NSManaged public func insertIntoCdNutrients(_ values: [CDNutrient], at indexes: NSIndexSet)

    @objc(removeCdNutrientsAtIndexes:)
    @NSManaged public func removeFromCdNutrients(at indexes: NSIndexSet)

    @objc(replaceObjectInCdNutrientsAtIndex:withObject:)
    @NSManaged public func replaceCdNutrients(at idx: Int, with value: CDNutrient)

    @objc(replaceCdNutrientsAtIndexes:withCdNutrients:)
    @NSManaged public func replaceCdNutrients(at indexes: NSIndexSet, with values: [CDNutrient])

    @objc(addCdNutrientsObject:)
    @NSManaged public func addToCdNutrients(_ value: CDNutrient)

    @objc(removeCdNutrientsObject:)
    @NSManaged public func removeFromCdNutrients(_ value: CDNutrient)

    @objc(addCdNutrients:)
    @NSManaged public func addToCdNutrients(_ values: NSOrderedSet)

    @objc(removeCdNutrients:)
    @NSManaged public func removeFromCdNutrients(_ values: NSOrderedSet)

}
