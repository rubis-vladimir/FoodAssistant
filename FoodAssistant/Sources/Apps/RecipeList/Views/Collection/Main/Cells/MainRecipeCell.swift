//
//  MainRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.11.2022.
//

import UIKit

class MainRecipeCell: UICollectionViewCell {
    
    weak var delegate: RecipeListPresentation?
    
    private var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(Icons.heartFill.image, for: .normal)
            } else {
                favoriteButton.setImage(Icons.heart.image, for: .normal)
            }
        }
    }
    
    let activity: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = Palette.darkColor.color
        return activity
    }()
    
    let recipeImageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    let favoriteButton: UIButton = {
        var button = UIButton()
        button.imageView?.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.layer.addShadow(color: Palette.darkColor.color, radius: 2, opacity: 0.4, offsetHeight: 1)
        return button
    }()
    
    let titleRecipeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cookingTimeLabel: UILabel = {
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
    
    @objc func didFavoriteButtonToggle() {
        isFavorite.toggle()
        print("asdasda")
    }
    
    func updateRecipeImage(data: Data) {
        activity.removeFromSuperview()
        recipeImageView.alpha = 0.5
        recipeImageView.reloadInputViews()
        
        UIView.animate(withDuration: 0.55) {
            if let image = UIImage(data: data) {
                self.recipeImageView.image = image
            } else {
                self.recipeImageView.image = Icons.basket.image
            }
            self.recipeImageView.alpha = 1
        }
    }
    
    func configure(with model: RecipeCellModel) {
        titleRecipeLabel.text = model.titleRecipe
        cookingTimeLabel.text = model.cookingTime
        
        if let urlString = model.imageName {
            let imageName = urlString.dropFirst(37)
            print(imageName)
            addSubview(activity)
            activity.setUpSpinner(loadingImageView: recipeImageView)
        }
    }
    
    func setupCell() {
        recipeImageView.layer.addShadow(color: Palette.shadowColor.color, radius: 10)
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 20
        
        favoriteButton.setImage(Icons.heart.image, for: .normal)
        favoriteButton.addTarget(self,
                                 action: #selector(didFavoriteButtonToggle),
                                 for: .touchUpInside)
    }
    
    
    
    func addEnding(number: Int) -> String {
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
   
    
    func setupConstraints() {
        
        let containerForLabel = UIStackView()
        containerForLabel.axis = .horizontal
        containerForLabel.alignment = .top
        containerForLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerForLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(cookingTimeLabel)
        
        stack.addArrangedSubview(recipeImageView)
        stack.addArrangedSubview(containerForLabel)
        
        addSubview(stack)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            cookingTimeLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            cookingTimeLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            containerForLabel.heightAnchor.constraint(equalToConstant: 45),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        addSubview(activity)
        activity.setUpSpinner(loadingImageView: recipeImageView)
    }
}

extension UIActivityIndicatorView {
    func setUpSpinner(loadingImageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: loadingImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor).isActive = true
    }
}
