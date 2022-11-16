//
//  TVFactoryProtocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import Foundation

/// Протокол фабрики для TableView
protocol TVFactoryProtocol {
    /// Строители ячеек
    var builders: [TVCBuilderProtocol] { get }
}
