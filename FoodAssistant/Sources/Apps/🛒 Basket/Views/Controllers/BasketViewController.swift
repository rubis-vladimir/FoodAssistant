//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем
protocol BasketViewable: AnyObject {
    /// Обновление UI
    func updateUI(with models: [RecipeProtocol])
    /// Показать ошибку
    func showError()
}

/// Контроллер представления корзины 
final class BasketViewController: UIViewController {

    private let presenter: BasketPresentation
    private var factory: CVFactoryProtocol?
    private var collectionView: UICollectionView!
    
    init(presenter: BasketPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupNavigitionBarViews()
        setupElements()
        
        presenter.fetchAddedRecipe()
    }
    
    func setupElements() {
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .blue
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
        
        let cancelLeftButton = createCustomBarButton(
            icon: .xmark,
            selector: #selector(cancelLeftButtonTapped)
        )
        
        let label = UILabel()
        label.text = "Корзина"
        
        navigationItem.leftBarButtonItems = [cancelLeftButton]
        navigationItem.titleView = label
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func saveAndExitRightButtonTapped() {
        
    }
    
    /// Скрывает экран
    @objc private func cancelLeftButtonTapped() {
        dismissVC()
    }
    
    private func dismissVC() {
        guard let nc = navigationController else { return }
        nc.createCustomTransition(with: .fade)
        nc.navigationBar.isHidden = true
        nc.popViewController(animated: false)
    }
}

// MARK: - BasketViewable
extension BasketViewController: BasketViewable {
    func updateUI(with models: [RecipeProtocol]) {
        factory = BasketFactory(collectionView: collectionView,
                                models: models,
                                delegate: presenter)
    }
    
    
    func showError() {
        
    }
}
