//
//  CVBaseRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// Варианты действия кнопки
enum TypeOfActionButton {
    /// Добавление в избранные
    case favorite(_ flag: Bool)
    /// Удаление рецепта
    case delete
}

/// #Базовая ячейка рецепта
class CVBaseRecipeCell: UICollectionViewCell {
    // MARK: - Properties
    weak var favoriteDelegate: FavoriteChangable?
    weak var deleteDelegate: DeleteTapable?
    weak var basketDelegate: InBasketTapable?

    /// Идентификатор рецепта
    var id: Int?
    /// Флаг избранного рецепта
    private var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                actionButton.setImage(Icons.heartFill.image, for: .normal)
            } else {
                actionButton.setImage(Icons.heart.image, for: .normal)
            }
        }
    }

    /// Индикатор загрузки
    var spinner: BallSpinFadeLoader?

    /// Вью для изображения рецепта
    let recipeImageView: UIImageView = {
        var imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.backgroundColor = .clear
        imv.tintColor = .white
        imv.clipsToBounds = true
        imv.isUserInteractionEnabled = true
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()

    /// Кнопка действия добавление в избранные/удаление
    let actionButton: UIButton = {
        var button = UIButton()
        button.imageView?.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Кнопка добавления корзину
    let addToBasketButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.basketSmall.image,
                        for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.titleLabel?.font = Fonts.main
        button.tintColor = .white
        button.layer.add(shadow: AppConstants.Shadow.defaultTwo)
        button.imageEdgeInsets = AppConstants.edgeInsertImageButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Лейбл с названием рецепта
    let titleRecipeLabel: UILabel = {
        var label = UILabel()
        label.font = Fonts.selected
        label.numberOfLines = 0
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

    /// Подложка для кнопки действия (отображается при типе Favorite)
    let substrateAction: UIImageView = {
        let imv = UIImageView()
        imv.isUserInteractionEnabled = true
        imv.tintColor = .white
        imv.backgroundColor = .clear
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()

    /// Подложка для лейбла времени
    let substrateTime: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 10
        stack.backgroundColor = .white
        stack.layer.borderColor = Palette.darkColor.color.cgColor
        stack.layer.borderWidth = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /// Контейнер лейбла для центровки сверху
    let containerTopLabel: UIStackView = {
        let stack = UIStackView()
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
    ///  - Parameters:
    ///   - model: вью модель рецепта
    ///   - type: вариант действия для кнопки
    func configure(with model: RecipeViewModel,
                   type: TypeOfActionButton) {
        titleRecipeLabel.text = model.title
        cookingTimeLabel.text = " " + model.cookingTime + " "
        id = model.id

        if model.imageName != nil {
            spinner = BallSpinFadeLoader()
            guard let spinner = spinner else {
                return
            }
            addSubview(spinner)
            spinner.setupSpinner(loadingImageView: recipeImageView)
        }

        switch type {
        case .favorite(let flag):
            isFavorite = flag
            actionButton.addTarget(self,
                                     action: #selector(didFavoriteButtonTapped),
                                     for: .touchUpInside)
            substrateAction.image = Icons.heartFill.image
        case .delete:
            actionButton.setImage(Icons.xmark.image, for: .normal)
            actionButton.addTarget(self,
                                     action: #selector(didDeleteButtonTapped),
                                     for: .touchUpInside)
        }
    }

    /// Обновляет изображение рецепта
    ///  - Parameter data: данные изображения
    func updateImage(data: Data) {
        spinner?.removeFromSuperview()
        spinner = nil
        recipeImageView.alpha = 0.5
        recipeImageView.reloadInputViews()

        UIView.animate(withDuration: 0.55) {
            if let image = UIImage(data: data) {
                self.recipeImageView.image = image
            } else {
                self.recipeImageView.image = UIImage(named: "defaultDish")
            }
            self.recipeImageView.alpha = 1
        }
    }

    /// Функция для настройки ячейки
    func setupCell() {
        addToBasketButton.addTarget(self,
                                    action: #selector(addToBasketButtonTapped),
                                    for: .touchUpInside)
        setupConstraints()
    }

    /// Функция для настройки констрейнтов
    func setupConstraints() {
        containerTopLabel.addArrangedSubview(titleRecipeLabel)
        substrateAction.addSubview(actionButton)

        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: substrateAction.topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: substrateAction.leadingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: substrateAction.bottomAnchor),
            actionButton.trailingAnchor.constraint(equalTo: substrateAction.trailingAnchor)
        ])
    }

    /// Нажата кнопка удаления рецепта
    @objc func didDeleteButtonTapped() {
        guard let id = id else { return }
        deleteDelegate?.didTapDeleteButton(id: id)
    }

    /// Нажата кнопка изменения флага любимого рецепта
    @objc func didFavoriteButtonTapped() {
        isFavorite.toggle()

        guard let id = id else { return }
        favoriteDelegate?.didTapFavoriteButton(isFavorite, id: id)
    }

    /// Нажата кнопка добавления в корзину ингредиентов рецепта
    @objc func addToBasketButtonTapped() {
        guard let id = id else { return }
        basketDelegate?.didTapAddInBasketButton(id: id)
    }
}
