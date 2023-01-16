//
//  UINavigationController + Transition.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.11.2022.
//

import UIKit

extension UINavigationController {
    /// Добавляет кастомную анимацию перехода снизу
    func createCustomTransition(with transitionType: CATransitionType) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = transitionType
        transition.subtype = CATransitionSubtype.fromTop
        
        self.view.layer.add(transition, forKey: nil)
    }
}
