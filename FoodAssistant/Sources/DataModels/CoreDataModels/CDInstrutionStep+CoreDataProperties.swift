//
//  CDInstrutionStep+CoreDataProperties.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//
//

import Foundation
import CoreData


extension CDInstrutionStep: InstructionStepProtocol {
    var number: Int { Int(cdNumber) }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInstrutionStep> {
        return NSFetchRequest<CDInstrutionStep>(entityName: "CDInstrutionStep")
    }

    @NSManaged public var cdNumber: Int16
    @NSManaged public var step: String
    @NSManaged public var recipe: CDRecipe?
}
