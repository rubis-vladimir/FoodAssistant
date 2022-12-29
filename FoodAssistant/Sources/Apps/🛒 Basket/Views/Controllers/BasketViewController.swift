//
//  BasketViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля Basket
protocol BasketPresentation: DeleteTapable,
                             ImagePresentation,
                             CellSelectable,
                             CheckChangable,
                             BackTapable,
                             AnyObject {
    /// Была нажата кнопка добавления в холодильник
    func didTapAddFridgeButton()
    /// Проверяет флаг ингредиента
    /// - Parameter id: идентификатор ингредиента
    func checkFlag(id: Int) -> Bool
}

/// #Контроллер представления Корзины
final class BasketViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: BasketPresentation
    private var factory: CVFactoryProtocol?
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                       collectionViewLayout: AppConstants.getFlowLayout())
    
    private lazy var addInFridgeButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Добавить", for: .normal)
        button.titleLabel?.font = Fonts.subtitle
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.setImage(Icons.fridge.image, for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.layer.add(shadow: AppConstants.Shadow.defaultOne)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var orderDeliveryButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Заказать", for: .normal)
        button.titleLabel?.font = Fonts.subtitle
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.setImage(Icons.fridge.image, for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.layer.add(shadow: AppConstants.Shadow.defaultOne)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stack = UIStackView()
    
    // MARK: - Init & ViewDidLoad
    init(presenter: BasketPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigitionBar()
        setupElements()
    }
    
    // MARK: - Private func
    private func setupElements() {
        
        addInFridgeButton.addTarget(self,
                                    action: #selector(addFridgeButtonTapped),
                                    for: .touchUpInside)
                
        /// Настройка `CollectionView`
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        
        stack.addArrangedSubview(addInFridgeButton)
        stack.addArrangedSubview(orderDeliveryButton)
        
        view.addSubview(collectionView)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// Настраивает NavigitionBar
    private func setupNavigitionBar() {
        navigationController?.navigationBar.isHidden = false
        
        let backButton = createCustomBarButton(
            icon: .xmark,
            selector: #selector(backButtonTapped)
        )
        
        let label = UILabel()
        label.text = "Корзина"
        
        navigationItem.leftBarButtonItems = [backButton]
        navigationItem.titleView = label
    }

    @objc private func backButtonTapped() {
        presenter.didTapBackButton()
    }
    
    @objc private func addFridgeButtonTapped() {
        presenter.didTapAddFridgeButton()
    }
}

// MARK: - BasketViewable
extension BasketViewController: BasketViewable {
    
    func updateCV(recipes: [RecipeProtocol],
                  ingredients: [IngredientViewModel]) {
        if recipes.isEmpty {
            factory = nil
            collectionView.reloadData()
        } else {
            factory = BasketFactory(collectionView: collectionView,
                                    recipes: recipes,
                                    ingredients: ingredients,
                                    delegate: presenter)
            collectionView.reloadData()
        }
    }
    
    func showAddButton(_ flag: Bool) {
        stack.isHidden = !flag
    }
    
    
    func show(error: Error) {
        
    }
}
