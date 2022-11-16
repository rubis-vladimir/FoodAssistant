//
//  UIView + Shadow.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.11.2022.
//

import UIKit

extension CALayer {
    
    func addShadow() {
        
        self.shadowColor = #colorLiteral(red: 0.01498480421, green: 0.1761765778, blue: 0.04584238678, alpha: 1).cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.shadowRadius = 5.0
        self.shadowOpacity = 0.5
    }
}
