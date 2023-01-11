//
//  UIViewController + AlertCheckDelete.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import UIKit

extension UIViewController {
    
    /// Показывает информационный алерт (заглушка)
    /// - Parameters:
    ///  - title: заголовок
    ///  - text: описание
    ///  - action: действие
    func showInformationAlert(title: String,
                              text: String,
                              action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
        
        if let action = action {
            let cancelAction = UIAlertAction(title: "Cancel".localize(), style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                action()
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
        }
        
        present(alert, animated: true)
    }
}
