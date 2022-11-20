//
//  UIView + Shadow.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.11.2022.
//

import UIKit

extension CALayer {
    
    func addShadow(color: UIColor = Palette.shadowColor.color,
                   radius: CGFloat = 3.0,
                   opacity: Float = 0.65,
                   offsetHeight: CGFloat = 1.0) {
        self.shadowColor = color.cgColor
        self.shadowOffset = CGSize(width: 0.0,
                                   height: offsetHeight)
        self.shadowRadius = radius
        self.shadowOpacity = opacity
    }
}
