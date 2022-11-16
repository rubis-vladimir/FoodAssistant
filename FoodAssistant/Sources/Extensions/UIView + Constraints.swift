//
//  UIView + Constraints.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 17.11.2022.
//

import UIKit

extension UIView {
    
    func pinEdges(to other: UIView, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -constant).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -constant).isActive = true
    }
}

