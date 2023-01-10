//
//  RecoverableError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 29.12.2022.
//

import Foundation

/// #Варианты опций восстановления ошибок
enum RecoveryOptions {
    /// попробовать снова
    case tryAgain(action: (() -> Void))
    /// отменить
    case cancel
}

/// #Восстанавливаемая ошибка
struct RecoverableError {
    /// Ошибка
    let error: Error
    /// Опции
    let recoveryOptions: [RecoveryOptions]
}
