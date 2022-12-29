//
//  Array + Duplicate.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.12.2022.
//

import Foundation

extension Array where Element: Equatable & Hashable {
    /// Возвращает массив дублирующихся значений
    func duplicate() -> [Element] {
       Array(Set(self.filter{ i in self.filter({ $0 == i }).count > 1}))
    }
}
