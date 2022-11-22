//
//  RecipeCollectionViewCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.11.2022.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: RecipeListPresentation?
    
    let activity: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = Palette.darkColor.color
        return activity
    }()
    
    private var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(Icons.heartFill.image, for: .normal)
            } else {
                favoriteButton.setImage(Icons.heart.image, for: .normal)
            }
        }
    }
    
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
        return button
    }()
    
    let titleRecipeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setupCell()
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didFavoriteButtonToggle() {
        isFavorite.toggle()
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
}

//    private func setupCell() {
//        backgroundColor = Palette.bgColor.color
//        clipsToBounds = true
//        layer.cornerRadius = 20
//        layer.addShadow(color: Palette.shadowColor.color, radius: 10)
//
//        favoriteButton.addTarget(self,
//                                 action: #selector(didFavoriteButtonToggle),
//                                 for: .touchUpInside)
//    }
//
    
    
//    private func addEnding(number: Int) -> String {
//        let endingBy10 = number % 10
//        let endingBy100 = number % 100
//        var baseString = "\(number) ИНГРЕДИЕНТ"
//
//        switch endingBy10 {
//        case 1:
//            baseString += 11 == endingBy100 ? "ОВ" : ""
//        case 2, 3, 4 :
//            baseString += 12...14 ~= endingBy100 ? "ОВ" : "А"
//        default:
//            baseString += "ОВ"
//        }
//        return baseString
//    }
   
    
//    private func setupConstraints() {
//
//        let containerForLabel = UIStackView()
//        containerForLabel.axis = .horizontal
//        containerForLabel.alignment = .top
//        containerForLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let stack = UIStackView()
//        stack.spacing = 16
//        stack.axis = .vertical
//        stack.distribution = .fillProportionally
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//
//        addToBasketButton.imageEdgeInsets = Constants.edgeInsert
//
//        containerForLabel.addArrangedSubview(titleRecipeLabel)
//        recipeImageView.addSubview(cookingTimeLabel)
//
//        stack.addArrangedSubview(containerForLabel)
//        stack.addArrangedSubview(addToBasketButton)
//
//        addSubview(recipeImageView)
//        addSubview(stack)
//        addSubview(favoriteButton)
//
//        NSLayoutConstraint.activate([
//            cookingTimeLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
//            cookingTimeLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
//
//            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//
//            containerForLabel.heightAnchor.constraint(equalToConstant: 45),
//            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
//
//            recipeImageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16),
//            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
//            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
//        ])
//        addSubview(activity)
//        activity.setUpSpinner(loadingImageView: recipeImageView)
//    }
    

extension UIActivityIndicatorView {
    func setUpSpinner(loadingImageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: loadingImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor).isActive = true
    }
}
