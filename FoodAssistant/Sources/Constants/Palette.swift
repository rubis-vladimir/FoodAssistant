//
//  Palette.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

enum Palette {
    case bgColor
    case lightColor
    case darkColor
    case shadowColor
}

extension Palette {
    var color: UIColor {
        switch self {
        case .bgColor: return #colorLiteral(red: 0.8609796166, green: 0.8864883184, blue: 0.791760385, alpha: 1)
        case .lightColor: return #colorLiteral(red: 0.650909543, green: 0.4934213161, blue: 0.4851912856, alpha: 1)
        case .darkColor: return #colorLiteral(red: 0.6, green: 0.1921568627, blue: 0.07843137255, alpha: 1)
        case .shadowColor: return #colorLiteral(red: 0.01498480421, green: 0.1761765778, blue: 0.04584238678, alpha: 1)
        }
    }
}
