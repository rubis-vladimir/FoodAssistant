//
//  UIViewController + AlertSetupTimer.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.01.2023.
//

import UIKit

extension UIViewController {
    
    /// Показывает алерт с настройкой времени таймера
    /// - Parameters:
    ///  - title: заголовок
    ///  - completion: захватывает количество секунд
    func showSetupTimerAlert(title: String,
                             completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: "\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        
        /// Устанавливаем frame для DatePicker
        datePicker.frame = .init(x: 5, y: 40, width: 260, height: 165)
    
        let cancelAction = UIAlertAction(title: "Cancel".localize(), style: .cancel)
        let okAction = UIAlertAction(title: "Start".localize(), style: .default) { _ in
            completion(Int(datePicker.countDownDuration))
        }
        
        alert.view.addSubview(datePicker)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
