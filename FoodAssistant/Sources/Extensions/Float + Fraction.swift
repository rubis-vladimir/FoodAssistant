//
//  Float + Fraction.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.12.2022.
//

import Foundation

extension Float {
    func rationalApproximationOf(withPrecision eps : Float = 1.0E-4) -> (Int, Int) {
        var x = self
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Float(k) * Float(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
}
