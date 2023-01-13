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
    
    func getStartData()
}

/// #Контроллер представления Корзины
final class BasketViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: BasketPresentation
    private var factory: BasketFactory?
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                       collectionViewLayout: AppConstants.getFlowLayout())
    
    private lazy var addInFridgeButton = BaseRedButton(title: " " + Constracts.addFridgeTitle,
                                                       image: Constracts.addFridgeImage) { [weak self] in
        self?.presenter.didTapAddFridgeButton()
    }
    
    private lazy var orderDeliveryButton = BaseRedButton(title: " " + Constracts.orderButtonTitle,
                                                       image: Constracts.orderBurronImage) { [weak self] in
        self?.showInformationAlert(title: "Order".localize(),
                                  text: "Go to checkout screen".localize())
    }
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
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
        presenter.getStartData()
    }
    
    // MARK: - Private func
    private func setupElements() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        stack.addArrangedSubview(addInFridgeButton)
        stack.addArrangedSubview(orderDeliveryButton)
        
        view.addSubview(collectionView)
        view.addSubview(stack)
        
        let padding = AppConstants.padding
        let heightStack: CGFloat = 50
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 2),
            stack.heightAnchor.constraint(equalToConstant: heightStack)
        ])
    }
    
    /// Настраивает NavigitionBar
    private func setupNavigitionBar() {
        navigationController?.navigationBar.isHidden = false
        
        let backButton = createCustomBarButton(
            icon: .xmark,
            selector: #selector(backButtonTapped)
        )
        
        navigationItem.leftBarButtonItems = [backButton]
        navigationItem.titleView = createNavTitle(title: "Basket".localize())
    }

    @objc private func backButtonTapped() {
        presenter.didTapBackButton()
    }
}

// MARK: - BasketViewable
extension BasketViewController: BasketViewable {
    
    func updateCV(recipes: [RecipeViewModel],
                  ingredients: [IngredientViewModel]) {
        if recipes.isEmpty {
            factory = nil
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                
                self.factory = BasketFactory(collectionView: self.collectionView,
                                        recipes: recipes,
                                        ingredients: ingredients,
                                             delegate: self.presenter)
                self.factory?.setupCollectionView()
            }
            
        }
    }
    
    func showAddButton(_ flag: Bool) {
        stack.isHidden = !flag
    }
}

// MARK: - Constants
extension BasketViewController {
    private struct Constracts {
        static let orderButtonTitle = "Order".localize()
        static let orderBurronImage = Icons.fridge.image
        static let addFridgeTitle = "Add".localize()
        static let addFridgeImage = Icons.cart.image
        
    }
}
