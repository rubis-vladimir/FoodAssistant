//
//  RecipeFilterView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.12.2022.
//

import Foundation
import UIKit
//import TagListView

/// #Вью фильтра и его элементов
class RecipeFilterView: UIView {
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cuisineLabel: UILabel = {
        createLabel(with: "Виды кухни")
    }()
    
    let cuisineFieldContainer: UIView = {
        createTextField(with: "Выберите кухню",
                        rightImage: Icons.chevronDown.image,
                        editable: false)
    }()
    
    private let dietLabel: UILabel = {
        createLabel(with: "Диета")
    }()
    
    let dietFieldContainer: UIView = {
        createTextField(with: "Выберите диету",
                        rightImage: Icons.chevronDown.image,
                        editable: false)
    }()
    
    private let intolerancesLabel: UILabel = {
        createLabel(with: "Непереносимость")
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cuisinePicker = UIPickerView()
    let dietPicker = UIPickerView()
    
    private let caloriesLabel: UILabel = {
        createLabel(with: "Каллории")
    }()
    
    let caloriesSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 2500
        slider.tintColor = .systemGreen
        slider.minimumValueImage = Icons.heart.image
        slider.maximumValueImage = Icons.heartFill.image
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let leftCaloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightCaloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "2500"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentCalories: UILabel = {
        let label = UILabel()
        label.text = "Максимум каллорий: 0"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setViews() {
        addSubview(contentView)
        contentView.addSubview(cuisineLabel)
        contentView.addSubview(cuisineFieldContainer)
        contentView.addSubview(dietLabel)
        contentView.addSubview(dietFieldContainer)
        contentView.addSubview(intolerancesLabel)
        contentView.addSubview(caloriesLabel)
        contentView.addSubview(caloriesSlider)
        contentView.addSubview(leftCaloriesLabel)
        contentView.addSubview(rightCaloriesLabel)
        contentView.addSubview(currentCalories)
        
        if let cuisineTextField = cuisineFieldContainer.subviews.first as? FilterTextField,
           let dietTextField = dietFieldContainer.subviews.first as? FilterTextField {
            cuisineTextField.inputView = cuisinePicker
            dietTextField.inputView = dietPicker
        }
    }
    
     func setupConstrains() {
        
        let spaceBetweenFilters: CGFloat = 30
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cuisineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cuisineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cuisineLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: spaceBetweenFilters),
            
            cuisineFieldContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cuisineFieldContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cuisineFieldContainer.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 10),
            cuisineFieldContainer.heightAnchor.constraint(equalToConstant: 55),
            
            dietLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dietLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dietLabel.topAnchor.constraint(equalTo: cuisineFieldContainer.bottomAnchor, constant: spaceBetweenFilters),
            
            dietFieldContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dietFieldContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dietFieldContainer.topAnchor.constraint(equalTo: dietLabel.bottomAnchor, constant: 10),
            dietFieldContainer.heightAnchor.constraint(equalToConstant: 50),
            
            intolerancesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            intolerancesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            intolerancesLabel.topAnchor.constraint(equalTo: dietFieldContainer.bottomAnchor, constant: spaceBetweenFilters),
            
            caloriesLabel.topAnchor.constraint(equalTo: intolerancesLabel.topAnchor, constant: 16),
            caloriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            caloriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            caloriesSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            caloriesSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            caloriesSlider.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 10),
            
            currentCalories.trailingAnchor.constraint(equalTo: caloriesSlider.trailingAnchor),
            currentCalories.bottomAnchor.constraint(equalTo: caloriesSlider.topAnchor, constant: -3),
            
            leftCaloriesLabel.leadingAnchor.constraint(equalTo: caloriesSlider.leadingAnchor),
            leftCaloriesLabel.topAnchor.constraint(equalTo: caloriesSlider.bottomAnchor, constant: 3),
            
            rightCaloriesLabel.trailingAnchor.constraint(equalTo: caloriesSlider.trailingAnchor),
            rightCaloriesLabel.topAnchor.constraint(equalTo: caloriesSlider.bottomAnchor, constant: 3)
        ])
    }
}

// Private support functions
private extension RecipeFilterView {
    // Created to avoid code duplication
    static func createTextField(with placeholder: String?,
                                rightImage: UIImage?,
                                editable: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = editable ? UITextField() : FilterTextField()
        textField.rightView = UIImageView(image: rightImage)
        textField.rightViewMode = .always
        textField.placeholder = placeholder
        textField.rightView?.tintColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        
        container.addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
        
        return container
    }
    
    static func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
