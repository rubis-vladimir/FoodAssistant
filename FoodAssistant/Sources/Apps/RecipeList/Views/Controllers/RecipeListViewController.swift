//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновление UI
    func updateUI(with type: RLBuildType)
    /// Показать ошибку
    func showError()
}

/// Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    private let presenter: RecipeListPresentation
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private var factory: RLFactory?
    
    init(presenter: RecipeListPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupElements()
    }
    
    private func setupElements() {
        /// `Navigation Bar` Setup
        navigationItem.title = "Food Assistant"
        
        /// `seacrhController` settings
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
        
        /// `CollectionView` settings
        let newFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.bounds.height ?? 0) + 13)
        collectionView = UICollectionView(frame: newFrame,
                                          collectionViewLayout: getFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        /// Adding elements to the screen
        view.addSubview(collectionView)
        
        /// Setting up the location of elements on the screen
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
//        layout.itemSize = calculateItemSize()
        return layout
    }
    
    /// Рассчитывает размер Item
    private func calculateItemSize() -> CGSize {
        let padding: CGFloat = 16
        let itemPerRow: CGFloat = 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (view.bounds.width - paddingWidht) / itemPerRow
        return CGSize(width: availableWidth,
                      height: availableWidth + padding + 40)
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI(with type: RLBuildType) {
        DispatchQueue.main.async {
            let models = self.presenter.viewModels
            self.factory = RLFactory(collectionView: self.collectionView,
                                buildType: type,
                                delegate: self.presenter)
            self.factory?.setupCollectionView()
        }
    }
    
    
    func showError() {
        
    }
}
