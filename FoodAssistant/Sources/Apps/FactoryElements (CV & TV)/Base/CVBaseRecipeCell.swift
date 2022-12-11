//
//  CVBaseRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// #Базовая ячейка рецепта
class CVBaseRecipeCell: UICollectionViewCell {
    
    // MARK: - Properties
    /// Идентификатор рецепта
    var id: Int?
    /// Флаг любимого рецепта
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(Icons.heartFill.image, for: .normal)
            } else {
                favoriteButton.setImage(Icons.heart.image, for: .normal)
            }
        }
    }
    /// Активити индикатор
    let activity: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = Palette.darkColor.color
        return activity
    }()
    
    /// Вью для изображения рецепта
    let recipeImageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.tintColor = .white
        iv.layer.add(shadow: AppConstants.Shadow.defaultOne)
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// Кнопка изменения флага любимого рецепта
    let favoriteButton: UIButton = {
        var button = UIButton()
        button.imageView?.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Лейбл с названием рецепта
    let titleRecipeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Лейбл с временем приготовления
    let cookingTimeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.textColor = Palette.darkColor.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Контейнер - подложка лейбла
    let containerCookingLabel: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 10
        stack.backgroundColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    /// Контейнер лейбла для центровки сверху
    let containerTitleLabel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    /// Конфигурирует ячейку по модели рецептов
    func configure(with model: RecipeViewModel) {
        titleRecipeLabel.text = model.title
        cookingTimeLabel.text = model.cookingTime + " "
        isFavorite = model.isFavorite
        id = model.id
        
        if model.imageName != nil {
            addSubview(activity)
            activity.setupSpinner(loadingImageView: recipeImageView)
        }
    }
    
    /// Обновляет изображение рецепта
    func updateImage(data: Data) {
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

    /// Функция для настройки ячейки
    func setupCell() {
        favoriteButton.addTarget(self,
                                 action: #selector(didFavoriteButtonToggle),
                                 for: .touchUpInside)
    }
    
    /// Нажата кнопка изменения флага любимого рецепта
    @objc func didFavoriteButtonToggle() {
        isFavorite.toggle()
    }
}

