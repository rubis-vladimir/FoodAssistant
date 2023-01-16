//
//  Images.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 17.11.2022.
//

import UIKit

/// #Изображения
enum Icons: String {
    case basket, fridge, fridgeFill, heart, heartFill, house, houseFill,
         person, personFill, split2x2, split1x2, basketSmall, xmark,
         heartLargeFill, leftFill, dish, clock, checkFill, circle, plusFill,
         magnifyingglass, sliders, personCard, personCardFill, cart, alarm, myPhoto
}

extension Icons {
    var image: UIImage? {
        UIImage(named: self.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
}
