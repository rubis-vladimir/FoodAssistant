//
//  CVIngredientCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

enum IngredientFlag {
    case toUse(_ flag: Bool)
    case isCheck(_ flag: Bool)
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
    weak var delegate: CheckChangable?
    
    private var isCheck: Bool = false {
        didSet {
            let image = isCheck ? Icons.checkFill.image : Icons.circle.image
            checkButton.setImage(image, for: .normal)
            
            guard let id = id else { return }
            delegate?.didTapCheckButton(id: id, flag: isCheck)
        }
    }
    
    private var id: Int?
    
    private lazy var ingredientView = IngredientView()

    /// Чек-кнопка
    private lazy var checkButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setupCell() {
        
        checkButton.addTarget(self,
                              action: #selector(didTapCheckButton),
                              for: .touchUpInside)
        setupConstraints()
    }
    
    func configure(with ingredient: IngredientViewModel,
                   flag: Bool) {
        id = ingredient.id
        ingredientView.configure(with: ingredient)
        
        isCheck = flag
    }
    
    func updateImage(with imageData: Data) {
        ingredientView.updateImage(with: imageData)
    }
    
    private func setupConstraints() {
        [ingredientView, checkButton].forEach {
            container.addArrangedSubview($0)
        }
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        
            checkButton.widthAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }
    
    @objc private func didTapCheckButton() {
        isCheck.toggle()
    }
}
