//
//  RecipeListSearchBar.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.12.2022.
//

import UIKit

/// #
protocol UISearchBarFilterDelegate: AnyObject {
    func changeFilterView(isFilter: Bool)
}

/// #Кастомный поисковой бар для рецептов
class RecipesSearchBar: UISearchBar {
    
    weak var filterDelegate: UISearchBarFilterDelegate?
    
    var isFilter: Bool = false {
        didSet {
            if isFilter {
                changeFilterButtonAppearance(with: .white, and: Palette.darkColor.color)
            } else {
                changeFilterButtonAppearance(with: .black, and: Palette.bgColor.color)
            }
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setViews() {
        placeholder = "Search recipes here...".localize()
        guard let textField = textField else {
            return
        }
        
        textField.leftView?.tintColor = Palette.darkColor.color
        textField.layer.shadowOffset = CGSize(width: 0, height: 3)
        textField.layer.shadowOpacity = 0.25
        
        textField.backgroundColor = .white
        textField.inputView?.layer.shadowOpacity = 0.25
        textField.inputView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        let textFieldBackground = textField.subviews.first
        
        textFieldBackground?.subviews.forEach({ $0.removeFromSuperview() })
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        addSubview(filterButton)
    }
    
    func setupConstrains() {
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
    
    func changeFilterButtonAppearance(with firstColor: UIColor, and secondColor: UIColor) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.filterButton.tintColor = firstColor
            self.filterButton.backgroundColor = secondColor
        }
        animator.startAnimation()
    }
}

private extension RecipesSearchBar {
    @objc func didTapFilterButton() {
        isFilter.toggle()
        filterDelegate?.changeFilterView(isFilter: isFilter)
    }
}

