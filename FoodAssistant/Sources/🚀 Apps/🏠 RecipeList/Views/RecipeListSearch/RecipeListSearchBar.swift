//
//  RecipeListSearchBar.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.12.2022.
//

import UIKit

/// #Протокол передачи UI-ивента нажатия на кнопку
protocol SearchBarFilterDelegate: AnyObject {
    /// Ивент нажатия на кнопку фильтра
    func didTapFilterButton()
}

/// #Кастомный поисковой бар для рецептов
class RecipesSearchBar: UISearchBar {
    
    // MARK: - Properties
    weak var filterDelegate: SearchBarFilterDelegate?
    
    /// Флаг фильтра
    var isFilter: Bool
    
    /// Текстовое поля для поиска
    private lazy var textField: UITextField? = {
        guard let textField = value(forKey: "searchField") as? UITextField else {
            print("Error")
            return nil
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Palette.bgColor.color
        
        button.setImage(Icons.sliders.image, for: .normal)
        button.tintColor = .black
        
        button.layer.cornerRadius = 13
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.25
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(isFilter: Bool) {
        self.isFilter = isFilter
        super.init(frame: CGRect.zero)
        
        setViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setViews() {
        
        if isFilter {
            changeFilterButtonAppearance(with: .white, and: Palette.darkColor.color)
        } else {
            changeFilterButtonAppearance(with: .black, and: Palette.bgColor.color)
        }
        
        backgroundImage = UIImage()
        
        placeholder = "Search recipes here...".localize()
        
        guard let textField = textField else { return }
        
        textField.leftView?.tintColor = Palette.darkColor.color
        textField.layer.shadowOffset = CGSize(width: 0, height: 3)
        textField.layer.shadowOpacity = 0.25
        
        textField.backgroundColor = .white
        textField.inputView?.layer.shadowOpacity = 0.25
        textField.inputView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let textFieldBackground = textField.subviews.first
        
        textFieldBackground?.subviews.forEach({ $0.removeFromSuperview() })
        filterButton.addTarget(self,
                               action: #selector(didTapFilterButton),
                               for: .touchUpInside)
        addSubview(filterButton)
    }
    
    private func setupConstrains() {
        guard let textField = textField else { return }
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.padding),
            textField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -AppConstants.padding),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.padding),
            filterButton.topAnchor.constraint(equalTo: textField.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            filterButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor),
        ])
    }
    
    /// Изменяет внешний вид кнопки фильтра с анимацией
    /// - Parameters:
    ///  - firstColor: цвет картинки
    ///  - secondColor: цвет заднего фона
    private func changeFilterButtonAppearance(with firstColor: UIColor,
                                              and secondColor: UIColor) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.filterButton.tintColor = firstColor
            self.filterButton.backgroundColor = secondColor
        }
        animator.startAnimation()
    }
}

private extension RecipesSearchBar {
    @objc func didTapFilterButton() {
        filterDelegate?.didTapFilterButton()
    }
}

