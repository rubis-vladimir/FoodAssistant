//
//  Assemblying.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол компоновки VIPER-модулей на базе UIViewController
protocol Assemblying {
    
    /// Собрать VIPER-модуль
    ///  - Returns: UIViewController компонующего модуля
    func assembly() -> UIViewController
}
