//
//  RecommendedRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import UIKit

final class RecommendedRecipeCell: RecipeCollectionViewCell {
//
//    private var isFavorite: Bool = false {
//        didSet {
//            if isFavorite {
//                favoriteButton.setImage(Icons.heartFill.image, for: .normal)
//            } else {
//                favoriteButton.setImage(Icons.heart.image, for: .normal)
//            }
//        }
//    }
    
    private lazy var addToBasketButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.basketSmall.image, for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.titleLabel?.font = Fonts.main
        button.layer.addShadow(color: Palette.shadowColor2.color)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var cookingTimeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.textColor = Palette.darkColor.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        setupConstraints()
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
    
    func configure(with model: RecipeCellModel) {
        addToBasketButton.setTitle("\(addEnding(number: model.ingredientsCount))",
                                   for: .normal)
        titleRecipeLabel.text = model.titleRecipe
        cookingTimeLabel.text = model.cookingTime
        
        if let urlString = model.imageName {
            let imageName = urlString.dropFirst(37)
            print(imageName)
            addSubview(activity)
            activity.setUpSpinner(loadingImageView: recipeImageView)
            
//            delegate?.fetchImage(with: String(imageName)) { [weak self] result in
//                switch result {
//                case .success(let data):
//                    guard let image = UIImage(data: data) else { return }
//                    DispatchQueue.main.async {
//                        self?.activity.removeFromSuperview()
//                        self?.recipeImageView.alpha = 0.5
//                        self?.recipeImageView.reloadInputViews()
//                        UIView.animate(withDuration: 0.55) {
//                            self?.recipeImageView.image = image
//                            self?.recipeImageView.alpha = 1
//                        }
//                    }
//                case .failure(_):
//                    break
//                }
//            }
        }
    }
    
    private func setupCell() {
        backgroundColor = Palette.bgColor.color
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.addShadow(color: Palette.shadowColor.color, radius: 10)
        
        favoriteButton.setImage(Icons.heart.image, for: .normal)
        favoriteButton.addTarget(self,
                                 action: #selector(didFavoriteButtonToggle),
                                 for: .touchUpInside)
    }
    
    
    
    private func addEnding(number: Int) -> String {
        let endingBy10 = number % 10
        let endingBy100 = number % 100
        var baseString = "\(number) ИНГРЕДИЕНТ"
        
        switch endingBy10 {
        case 1:
            baseString += 11 == endingBy100 ? "ОВ" : ""
        case 2, 3, 4 :
            baseString += 12...14 ~= endingBy100 ? "ОВ" : "А"
        default:
            baseString += "ОВ"
        }
        return baseString
    }
   
    
    private func setupConstraints() {
        
        let containerForLabel = UIStackView()
        containerForLabel.axis = .horizontal
        containerForLabel.alignment = .top
        containerForLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        addToBasketButton.imageEdgeInsets = Constants.edgeInsert
        
        containerForLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(cookingTimeLabel)
        
        stack.addArrangedSubview(containerForLabel)
        stack.addArrangedSubview(addToBasketButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            cookingTimeLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            cookingTimeLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            containerForLabel.heightAnchor.constraint(equalToConstant: 45),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            
            recipeImageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        addSubview(activity)
        activity.setUpSpinner(loadingImageView: recipeImageView)
    }
}
