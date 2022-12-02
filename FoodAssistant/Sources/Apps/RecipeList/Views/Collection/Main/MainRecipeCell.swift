//
//  MainRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.11.2022.
//

import UIKit

class MainRecipeCell: UICollectionViewCell {
    
    weak var delegate: RLRecipeButtonDelegate?
    
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
//        button.imageView?.layer.addShadow(color: Palette.darkColor.color,
//                                          radius: 2,
//                                          opacity: 0.4,
//                                          offset: CGSize(width: 0, height: 1))
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
    
    let containerForCTLabel: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 10
        stack.backgroundColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
//        delegate?.didTapFavoriteButton(id: 1)
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
        cookingTimeLabel.text = model.cookingTime + " "
        
        if let urlString = model.imageName {
            let imageName = urlString.dropFirst(37)
            print(imageName)
            addSubview(activity)
            activity.setUpSpinner(loadingImageView: recipeImageView)
        }
    }
    
    func setupCell() {
        recipeImageView.layer.add(shadow: AppConstants.Shadow.defaultOne)
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 20
        
        favoriteButton.setImage(Icons.heart.image, for: .normal)
        favoriteButton.addTarget(self,
                                 action: #selector(didFavoriteButtonToggle),
                                 for: .touchUpInside)
    }
    func setupConstraints() {
        
        let containerForTRLabel = UIStackView()
        containerForTRLabel.axis = .horizontal
        containerForTRLabel.alignment = .top
        containerForTRLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        containerForCTLabel.addArrangedSubview(cookingTimeLabel)
        containerForTRLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(containerForCTLabel)
        
        stack.addArrangedSubview(recipeImageView)
        stack.addArrangedSubview(containerForTRLabel)
        
        addSubview(stack)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            containerForCTLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            containerForCTLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            containerForCTLabel.heightAnchor.constraint(equalToConstant: 30),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: containerForCTLabel.leadingAnchor, constant: 4),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            containerForTRLabel.heightAnchor.constraint(equalToConstant: 45),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        addSubview(activity)
        activity.setUpSpinner(loadingImageView: recipeImageView)
    }
}

//extension MainRecipeCell

extension UIActivityIndicatorView {
    func setUpSpinner(loadingImageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: loadingImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor).isActive = true
    }
}
