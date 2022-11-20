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
    func updateUI(with models: [RecipeCellModel])
    /// Показать ошибку
    func showError()
}

/// Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {
    
    //    typealias DataSource = UICollectionViewDiffableDataSource<RecipeListSection, Recipe>
    //    typealias Snapshot = NSDiffableDataSourceSnapshot<RecipeListSection, Recipe>
    
    private var models: [RecipeCellModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
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
//        presenter.testTranslate()
        presenter.testGetRandom()
//        presenter.testGetRecipe()
        setupElements()
    }
    
    private func setupElements() {
        /// `Navigation Bar` Setup
        navigationItem.title = "Food Assistant"
//        navigationController?.navigationBar.tintColor = .black
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
        let newFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.bounds.height ?? 0) + 13)
        collectionView = UICollectionView(frame: newFrame,
                                          collectionViewLayout: getFlowLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Registration of cells
        collectionView.register(RecipeCell.self)
        
        /// Adding elements to the screen
        view.addSubview(collectionView)
        
        /// Setting up the location of elements on the screen
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
//        NSLayoutConstraint.activate([
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
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
        layout.scrollDirection = .horizontal
        layout.itemSize = calculateItemSize()
        return layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(view.bounds.width)
    }
    
    /// Рассчитывает размер Item
    private func calculateItemSize() -> CGSize {
//        let padding: CGFloat = 16
//        let itemPerRow: CGFloat = 1
//        let paddingWidht = padding * (itemPerRow + 1)
//        let availableWidth = (view.bounds.width - paddingWidht) / itemPerRow
//        return CGSize(width: availableWidth,
//                      height: availableWidth * 1.2)
        
        
        let padding: CGFloat = 16
        let itemPerRow: CGFloat = 1
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = view.bounds.width * 0.8 - paddingWidht
        return CGSize(width: availableWidth,
                      height: availableWidth * 1.5)
        
    }
    
    @objc func clickChangeViewButton() {
        
    }
}

extension RecipeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecipeCell.self, indexPath: indexPath)
        
        let model = models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension RecipeListViewController: UICollectionViewDelegate {
    
}

extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI(with models: [RecipeCellModel]) {
        self.models = models
    }
    
    
    func showError() {
        
    }
}
