//
//  DetailTitleView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.11.2022.
//

import UIKit

/// #Кастомный вью с информацией о рецепте
final class DetailTitleView: UIView {

    // MARK: - Properties
    /// Лейбл с названием рецепта
    let titleRecipeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.subtitle
        label.numberOfLines = 0
        return label
    }()

    /// Лейбл с временем приготовления
    let cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.selected
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()

    /// Лейбл с количеством порций
    let numberServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.selected
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function
    func setupElements() {
        backgroundColor = Palette.bgColor.color
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        layer.cornerRadius = AppConstants.cornerRadius

        /// Дефолтный лейбл
        let label = UILabel()
        label.text = "RECIPE".localize()
        label.font = Fonts.main

        /// Контейнер для названия рецепта
        let containerForTitle = UIStackView()
        containerForTitle.axis = .vertical
        containerForTitle.spacing = 8
        containerForTitle.distribution = .fillProportionally
        containerForTitle.alignment = .center
        containerForTitle.translatesAutoresizingMaskIntoConstraints = false

        /// Вспомогательный контейнер
        let supContainer = UIStackView()
        supContainer.spacing = 20
        supContainer.distribution = .fillProportionally

        let cookingTimeStack = createStack(label: cookingTimeLabel,
                                           image: Icons.clock.image)
        let numberServingsStack = createStack(label: numberServingsLabel,
                                              image: Icons.dish.image)

        supContainer.addArrangedSubview(cookingTimeStack)
        supContainer.addArrangedSubview(numberServingsStack)

        [label, titleRecipeLabel, supContainer].forEach {
            containerForTitle.addArrangedSubview($0)
        }

        addSubview(containerForTitle)

        /// Констрейнты
        let padding: CGFloat = AppConstants.padding

        NSLayoutConstraint.activate([
            containerForTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            containerForTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            containerForTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            containerForTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
    }

    /// Создает стэк с лейблом и изображением
    func createStack(label: UILabel,
                     image: UIImage?) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 8
        let imv = UIImageView()
        imv.image = image
        stack.addArrangedSubview(imv)
        stack.addArrangedSubview(label)
        return stack
    }
}
