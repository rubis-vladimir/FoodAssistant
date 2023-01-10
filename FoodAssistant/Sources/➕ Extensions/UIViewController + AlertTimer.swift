//
//  UIViewController + AlertTimer.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 05.01.2023.
//

import UIKit

extension UIViewController {
    
    /// #Алерт с таймером обратного отсчета - В РАЗРАБОТКЕ
    func showCountdownTimer(startTime: (Int, Int),
                            completion: @escaping (Date) -> Void) {
        
        let alert = UIAlertController(title: nil,
                                      message: "\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.view.backgroundColor = Palette.bgColor.color
        alert.view.layer.cornerRadius = 10
        
        let timePicker = UIPickerView()
        
        let titleLabel = UILabel()
        titleLabel.font = Fonts.subtitle
        titleLabel.text = "Timer".localize()
        titleLabel.textAlignment = .center
        
        let annotationLabel = UILabel()
        annotationLabel.font = Fonts.annotation
        annotationLabel.numberOfLines = 0
        annotationLabel.text = ""
        annotationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(timePicker)
        stack.addArrangedSubview(annotationLabel)
        alert.view.addSubview(stack)
        
        /// Добавляем скрытие клавиатуры
        addHideKeyboard(alert.view)
        
        /// Настраиваем констрейнты
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60)
        ])
        
        alert.addAction(UIAlertAction(title: "Cancel".localize(),
                                      style: .cancel,
                                      handler: nil))
//        alert.addAction(UIAlertAction(title: "Start".localize(),
//                                      style: .default,
//                                      handler: { _ in completion(datePicker.date) }))
        
        self.present(alert, animated: true)
    }
}
