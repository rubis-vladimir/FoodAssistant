//
//  CVIngredientCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

/// #Варианты кнопки в ячейке игредиента
enum IngredientCellButtonType {
    /// Подтверждение
    case check
    /// Удаление
    case delete
}

/// #Протокол изменения флага подтверждения
protocol CheckChangable: AnyObject {
    /// Ивент при нажатии на чек-кнопку
    /// - Parameters:
    ///  - id: идентификатор
    ///  - flag: флаг подтверждения
    func didTapCheckButton(id: Int,
                           flag: Bool)
}

/// #Ячейка отображения ингредиента с чек-кнопкой
class CVIngredientCell: UICollectionViewCell {
    // MARK: - Properties
    weak var checkDelegate: CheckChangable?
    weak var deleteDelegate: DeleteTapable?

    var isEditing: Bool = false {
        didSet {
            changeActionButtonImage()
        }
    }

    private var isCheck: Bool = false {
        didSet {
            guard !isEditing else { return }

            changeActionButtonImage()

            guard let id = id else { return }
            checkDelegate?.didTapCheckButton(id: id, flag: isCheck)
        }
    }

    private var id: Int?

    private lazy var ingredientView = IngredientView()

    /// Кнопка действия
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Общий контейнер
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 16
        stack.alignment = .fill
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
    
    deinit {
        print("DEINIT \(self) - \(id)")
    }

    // MARK: - Functions
    func setupCell() {
        actionButton.addTarget(self,
                              action: #selector(didTapActionButton),
                              for: .touchUpInside)
        setupConstraints()
    }

    func configure(with ingredient: IngredientViewModel,
                   flag: Bool,
                   editing: Bool) {
        id = ingredient.id
        ingredientView.configure(with: ingredient)
        isCheck = flag
        isEditing = editing
        changeActionButtonImage()
    }

    func updateImage(with imageData: Data) {
        ingredientView.updateImage(with: imageData)
    }

    private func setupConstraints() {
        [ingredientView, actionButton].forEach {
            container.addArrangedSubview($0)
        }
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            actionButton.widthAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }

    /// Изменяет изображение кнопки
    private func changeActionButtonImage() {
        if isEditing {
            actionButton.setImage(Icons.xmark.image,
                                 for: .normal)
        } else {
            let image = isCheck ? Icons.checkFill.image : Icons.circle.image
            actionButton.setImage(image, for: .normal)
        }
    }

    @objc private func didTapActionButton() {
        if isEditing {
            guard let id = id else { return }
            deleteDelegate?.didTapDeleteButton(id: id)
        } else {
            isCheck.toggle()
        }
    }
}
