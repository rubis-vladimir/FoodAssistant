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
                             AnyObject {
    func fetchAddedRecipe()
    
    func route(to: BasketTarget)
}

/// #Контроллер представления Корзины
final class BasketViewController: UIViewController {

    // MARK: - Properties
    private let presenter: BasketPresentation
    private var factory: CVFactoryProtocol?
    private var collectionView: UICollectionView!
    
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
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        }
    }
    
    
    func showError() {
        
    }
}
