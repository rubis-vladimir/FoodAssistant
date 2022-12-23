//
//  BasketViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля Basket
protocol BasketPresentation: RecipeRemovable,
                             ImagePresentation,
                             SelectedCellDelegate,
                             CheckChangable,
                             AnyObject {
    
    func fetchAddedRecipe()
    
    func didTapAddFridgeButton()
    
    func checkFlag(id: Int) -> Bool
        
    /// Ивент перехода
    /// - Parameter to: цель перехода
    func route(to: BasketTarget)
}

/// #Контроллер представления Корзины
final class BasketViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: BasketPresentation
    private var factory: CVFactoryProtocol?
    private var collectionView: UICollectionView!
    
    private lazy var addInFridgeButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Добавить", for: .normal)
        
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.setImage(Icons.fridge.image, for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.layer.add(shadow: AppConstants.Shadow.defaultOne)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init & ViewDidLoad
    init(presenter: BasketPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT \(self)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupNavigitionBarViews()
        setupElements()
        
        presenter.fetchAddedRecipe()
    }
    
    // MARK: - Private func
    private func setupElements() {
        
        addInFridgeButton.addTarget(self, action: #selector(didTapAddFridgeButton), for: .touchUpInside)
        addInFridgeButton.isHidden = true
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(addInFridgeButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addInFridgeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addInFridgeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            addInFridgeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addInFridgeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// Возвращает настроенный `FlowLayout`
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding = AppConstants.padding
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
    
    /// Настраивает кастомный NavigitionBar
    private func setupNavigitionBarViews() {
        
        let dismissButton = createCustomBarButton(
            icon: .xmark,
            selector: #selector(dismissButtonTapped)
        )
        
        let label = UILabel()
        label.text = "Корзина"
        
        navigationItem.leftBarButtonItems = [dismissButton]
        navigationItem.titleView = label
    }

    /// Скрывает экран
    @objc private func dismissButtonTapped() {
        presenter.route(to: .back)
    }
    
    @objc private func didTapAddFridgeButton() {
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
        addInFridgeButton.isHidden = !flag
    }
    
    
    func showError() {
        
    }
}
