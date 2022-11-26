//
//  DetailTitleView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.11.2022.
//

import UIKit

final class DetailTitleView: UIView {
    
    let titleRecipeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.subtitle
        label.numberOfLines = 0
        label.text = "Прибрежный салат из авокадо с виноградом и креветками"
        return label
    }()
    
    let cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.selected
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "2 ч 25 мин"
        return label
    }()
    
    let numberServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.selected
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "5 Порций"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Palette.bgColor.color
        layer.addShadow()
        layer.cornerRadius = 20
        
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupElements() {
        /// Дефолтный лейбл
        let label = UILabel()
        label.text = "РЕЦЕПТ"
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
                                           image: UIImage(named: "clock")!)
        let numberServingsStack = createStack(label: numberServingsLabel,
                                           image: UIImage(named: "dish")!)
        
        supContainer.addArrangedSubview(cookingTimeStack)
        supContainer.addArrangedSubview(numberServingsStack)
        
        [label, titleRecipeLabel, supContainer].forEach {
            containerForTitle.addArrangedSubview($0)
        }
        
        addSubview(containerForTitle)
        
        NSLayoutConstraint.activate([
            containerForTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            containerForTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            containerForTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerForTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func createStack(label: UILabel,
                     image: UIImage) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
//        stack.backgroundColor =
        
        let iv = UIImageView()
        iv.image = image
        
        stack.addArrangedSubview(iv)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    func setupConstraints() {
        
    }
    
}
