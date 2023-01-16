//
//  UIViewController + Alert.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 27.12.2022.
//

import UIKit

extension UIViewController {
    /// Показывает алерт с TextView
    /// - Parameters:
    ///  - title: заголовок
    ///  - text: основной текст
    ///  - note: заметка
    ///  - completion: захватывает текст в TV
    func showTVAlert(title: String,
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
        alert.addAction(UIAlertAction(title: "Add".localize(),
                                      style: .default,
                                      handler: { _ in completion(textView.text) }))

        self.present(alert, animated: true)
    }

    /// Показывает алерт для добавления ингредиента
    /// - Parameter completion: захватывает модель ингредиента/ошибку
    func showAddIngredientAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void) {
        let alert = UIAlertController(title: nil,
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        alert.view.backgroundColor = Palette.bgColor.color
        alert.view.layer.cornerRadius = 10

        let titleTF = UITextField()
        let amountTF = UITextField()
        let unitTF = UITextField()

        let container = createStackForIngredientAlert(titleTF: titleTF,
                                                      amountTF: amountTF,
                                                      unitTF: unitTF)

        /// Добавляем скрытие клавиатуры
        addHideKeyboard(alert.view)
        alert.view.addSubview(container)

        /// Настройка констрейнтов
        let padding = AppConstants.padding

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: padding),
            container.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: padding),
            container.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -padding)
        ])

        alert.addAction(UIAlertAction(title: "Cancel".localize(),
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Add".localize(),
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.validateIngredient(textTitle: titleTF.text,
                               textAmount: amountTF.text,
                               textUnit: unitTF.text,
                               completion: completion)
        }))
        present(alert, animated: true)
    }

    /// Добавляет ивент скрытия клавиатуры при касании
    func addHideKeyboard(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: view,
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    /// Создает и наполняет контейнер для алерта добавления ингредиента
    private func createStackForIngredientAlert(titleTF: UITextField,
                                               amountTF: UITextField,
                                               unitTF: UITextField) -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 16
        container.translatesAutoresizingMaskIntoConstraints = false

        let headerLabel = UILabel()
        headerLabel.font = Fonts.subtitle
        headerLabel.text = "Add Ingredient".localize()
        headerLabel.textAlignment = .center

        container.addArrangedSubview(headerLabel)

        let titles = ["Name".localize(), "Amount".localize(), "Unit".localize()]

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
        return container
    }

    /// Проверяет введенные данные
    /// - Parameters:
    ///  - textTitle: текст в titleTF
    ///  - textAmount: текст в amountTF
    ///  - textUnit: текст в unitTF
    ///  - completion: захватывает Вью модель ингредиента/ ошибку
    private func validateIngredient(textTitle: String?,
                                    textAmount: String?,
                                    textUnit: String?,
                                    completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void) {
        guard let title = textTitle?.lowercased(),
              let amount = textAmount,
              title != "", amount != "" else {
            completion(.failure(.notDataProvided))
            return
        }

        if let amount = Float(amount) {
            let model = IngredientViewModel(id: 0,
                                            image: nil,
                                            name: title,
                                            amount: amount,
                                            unit: textUnit?.lowercased() ?? "")
            completion(.success(model))
        } else {
            completion(.failure(.invalidNumber))
        }
    }
}
