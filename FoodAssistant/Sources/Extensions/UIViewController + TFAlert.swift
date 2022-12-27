//
//  UIViewController + TFAlert.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 27.12.2022.
//

import UIKit

extension UIViewController {
    
    func showTFAlert(title: String,
                     text: String,
                     note: String,
                     completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: nil,
                                      message: "\n\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.view.backgroundColor = Palette.bgColor.color
        alert.view.layer.cornerRadius = 10
        
        let textView = UITextView()
        textView.text = text
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = Fonts.main
        textView.layer.cornerRadius = 10
        
        let titleLabel = UILabel()
        titleLabel.font = Fonts.subtitle
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        let annotationLabel = UILabel()
        annotationLabel.font = Fonts.annotation
        annotationLabel.numberOfLines = 0
        annotationLabel.text = note
        annotationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(textView)
        stack.addArrangedSubview(annotationLabel)
        alert.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60),
            
//            noteLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Добавить",
                                      style: .default,
                                      handler: { _ in completion(textView.text) }))
        
        self.present(alert, animated: true)
    }
}
