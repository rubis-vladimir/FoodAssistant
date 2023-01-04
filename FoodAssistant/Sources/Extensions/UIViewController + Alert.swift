//
//  UIViewController + Alert.swift
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
        alert.addAction(UIAlertAction(title: "Add".localize(),
                                      style: .default,
                                      handler: { _ in completion(textView.text) }))
        
        self.present(alert, animated: true)
    }
    
    
    func showAddIngredientAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void) {
        
        let alert = UIAlertController(title: nil,
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.view.backgroundColor = Palette.bgColor.color
        alert.view.layer.cornerRadius = 10
        
        let titles = ["Name".localize(),
                      "Amount".localize(),
                      "Unit".localize()]
        
        let titleTF = UITextView()
        let amountTF = UITextView()
        let unitTF = UITextView()
        
        let headerLabel = UILabel()
        headerLabel.font = Fonts.subtitle
        headerLabel.text = "Add Ingredient".localize()
        headerLabel.textAlignment = .center
        
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addArrangedSubview(headerLabel)
        
        [titleTF, amountTF, unitTF].enumerated().forEach {
            $0.element.layer.borderColor = UIColor.lightGray.cgColor
            $0.element.layer.borderWidth = 0.5
            $0.element.layer.cornerRadius = 5
            $0.element.backgroundColor = .white
            $0.element.translatesAutoresizingMaskIntoConstraints = false
            
            $0.element.widthAnchor.constraint(equalToConstant: 100).isActive = true
            $0.element.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let label = UILabel()
            label.text = titles[$0.offset]
            label.font = Fonts.selected
            
            let stack = UIStackView()
            stack.spacing = 10
            stack.addArrangedSubview(label)
            stack.addArrangedSubview($0.element)
            
            container.addArrangedSubview(stack)
        }
        
        alert.view.addSubview(container)
        
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: padding),
            container.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: padding),
            container.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -padding),
        ])
        
        alert.addAction(UIAlertAction(title: "Cancel".localize(),
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Add".localize(),
                                      style: .default,
                                      handler: { _ in
            
            if let amount = Float(amountTF.text ?? "") {
                let model = IngredientViewModel(id: 0,
                                                image: nil,
                                                name: titleTF.text.lowercased(),
                                                amount: amount,
                                                unit: unitTF.text.lowercased())
                completion(.success(model))
            } else {
                completion(.failure(.invalidNumber))
            }
        }))
        
        present(alert, animated: true)
    }
    
    /// Показывает информационный алерт (заглушка)
    /// - Parameters:
    ///  - title: заголовок
    ///  - text: описание
    func showInformationAlert(title: String,
                              text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) 
        alert.addAction(action)

        present(alert, animated: true)
    }
}
