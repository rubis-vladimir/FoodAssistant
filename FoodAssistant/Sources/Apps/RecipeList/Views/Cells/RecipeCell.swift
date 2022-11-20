//
//  RecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.11.2022.
//

import UIKit

final class RecipeCell: UICollectionViewCell {
    
    private var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(Icons.heartFill.image, for: .normal)
            } else {
                favoriteButton.setImage(Icons.heart.image, for: .normal)
            }
        }
    }
    
    private lazy var recipeImageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        iv.image = UIImage(named: "треска")
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var addToBasketButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage()
        
        button.setImage(Icons.basketSmall.image, for: .normal)
        button.setTitle("13 ИНГРЕДИЕНТОВ", for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.titleLabel?.font = Fonts.main
        button.layer.addShadow(color: Palette.shadowColor2.color)
        button.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        var button = UIButton()
        
//        if #available(iOS 13.0, *) {
//            let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
//            let image = UIImage(systemName: "heart", withConfiguration: iconConfiguration)
//            button.setImage(image, for: .normal)
//        } else {
//            // Fallback on earlier versions
//        }
        button.setImage(Icons.heart.image, for: .normal)
        button.imageView?.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.minimumScaleFactor = 0.5
        return button
    }()
    
    private lazy var cookingTimeLabel: UILabel = {
        var label = UILabel()
        label.text = "25 мин"
        label.font = Fonts.selected
        label.textColor = Palette.darkColor.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleRecipeLabel: UILabel = {
        var label = UILabel()
        label.text = "Какой-то рецепт - неебическая треска с овощами-гриль"
        label.font = Fonts.selected
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupConstraints()
        print(recipeImageView.bounds.minX)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addToBasketButton.layer.cornerRadius = addToBasketButton.frame.height / 2
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }
    
    @objc func addToBasketButtonTapped() {
        print("addToBasketButtonTapped")
    }
    
    @objc func didFavoriteButtonToggle() {
        isFavorite.toggle()
    }
    
    func setupCell() {
        layer.cornerRadius = 20
        layer.addShadow(color: Palette.shadowColor.color)
        backgroundColor = Palette.bgColor.color
        layoutSubviews()
        
        favoriteButton.addTarget(self, action: #selector(didFavoriteButtonToggle), for: .touchUpInside)
    }
    
    func configure(with model: RecipeCellModel) {
        isFavorite = model.isFavorite
        
        addToBasketButton.setTitle("\(addEnding(number: model.ingredientsCount))",
                                   for: .normal)
        if let data = model.imageData {
            recipeImageView.image = UIImage(data: data)
        }
        
        titleRecipeLabel.text = model.titleRecipe
        cookingTimeLabel.text = model.cookingTime
    }
    
    private func addEnding(number: Int) -> String {
        let endingBy10 = number % 10
        let endingBy100 = number % 100
        
        switch endingBy10 {
        case 1 where !(11...19 ~= endingBy100):
            return "\(number) ИНГРЕДИЕНТ"
        case 2, 3,
            4 where !(11...19 ~= endingBy100):
            return "\(number) ИНГРЕДИЕНТА"
        default:
            return "\(number) ИНГРЕДИЕНТОВ"
        }
    }
   
    
    private func setupConstraints() {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        
        let containerForLabel = UIStackView()
        containerForLabel.axis = .horizontal
        containerForLabel.alignment = .top
        containerForLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerForLabel.addArrangedSubview(titleRecipeLabel)
        
//        stack.addArrangedSubview(containerForLabel)
//        stack.addArrangedSubview(addToBasketButton)
//
        
        recipeImageView.addSubview(cookingTimeLabel)
        
        
        let mainStack = UIStackView()
        mainStack.spacing = 16
        mainStack.axis = .vertical
        mainStack.distribution = .fillProportionally
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addToBasketButton.imageEdgeInsets = Constants.edgeInsert
        
        mainStack.addArrangedSubview(recipeImageView)
        mainStack.addArrangedSubview(containerForLabel)
        mainStack.addArrangedSubview(addToBasketButton)
        
        addSubview(mainStack)
        addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            
            cookingTimeLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            cookingTimeLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            containerForLabel.heightAnchor.constraint(equalToConstant: 45),
            containerForLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            containerForLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),
            addToBasketButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),
            
            addToBasketButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            addToBasketButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        mainStack.clipsToBounds = true
        mainStack.layer.cornerRadius = 20
        
    }
}
