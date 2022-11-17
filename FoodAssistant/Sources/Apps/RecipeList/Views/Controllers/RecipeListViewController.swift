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
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

//    typealias DataSource = UICollectionViewDiffableDataSource<RecipeListSection, Recipe>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<RecipeListSection, Recipe>
    
    private let presenter: RecipeListPresentation
    private var collectionView: UICollectionView!
//    private var dataSource: DataSource?
    private var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    
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
//        tabBarController?.navigationController?.navigationBar.isHidden = false
//        presenter.testTranslate()
//        presenter.testGetRandom()
//        presenter.testGetRecipe()
        setupElements()
    }
    
    private func setupElements() {
        /// `Navigation Bar` Setup
        
        navigationItem.title = "Food Assistant"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icons.split2x2.image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(clickChangeViewButton))
        
        /// `seacrhController` settings
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
        
        /// `CollectionView` settings
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setViewLayout(numberOfLayoutType))
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .clear
//
//        collectionView.delegate = self
        
        /// Registration of cells
//        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        
        /// Adding elements to the screen
//        view.addSubview(collectionView)
        
        /// Setting up the location of elements on the screen
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
//        NSLayoutConstraint.activate([
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
    }
    
    @objc func clickChangeViewButton() {
        
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
