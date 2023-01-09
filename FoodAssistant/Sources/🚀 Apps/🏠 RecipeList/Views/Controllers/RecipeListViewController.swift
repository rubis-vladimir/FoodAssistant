//
//  RecipeListViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: LayoutChangable,
                                 CellSelectable,
                                 FavoriteChangable,
                                 InBasketTapable,
                                 ImagePresentation,
                                 AnyObject {
    /// Ивент нажатия на кнопку фильтр
    func didTapFilterButton()
    /// Обновить новые данные
    func updateNewData()
    /// Проверить избранный ли рецепт
    func checkFavorite(id: Int) -> Bool
}

/// #Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    // MARK: - Properties
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                                        collectionViewLayout: AppConstants.getFlowLayout())
    
    private var timer: Timer?
    private var factory: RLFactory?
    
    private let presenter: RecipeListPresentation
    private let searchBar = RecipesSearchBar(isFilter: false)
    
//    private var isSearching: Bool = false
//    private var isChangingFilters: Bool = false
    private var selectedSegment: Int = 0
    
    private lazy var navLabel = createNavTitle(title: "FoodAssistant")
    
    // MARK: - Init & ViewDidLoad
    init(presenter: RecipeListPresentation) {
        self.presenter = presenter
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.updateNewData()
    }
    
    func configureSearchController() {
        searchBar.delegate = self
        searchBar.filterDelegate = self
    }
    
    // MARK: - Private func
    private func setupElements() {
        navigationItem.titleView = navLabel
        navigationController?.navigationBar.shadowImage = UIImage()
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        /// Настройка констрейнтов
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
        ])
    }
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func show(rError: RecoverableError) {
        DispatchQueue.main.async {
            self.showAlertError(rError)
        }
    }
    
    func updateItems(indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func getSearchText() -> String? {
        searchBar.text
    }
    
    func updateCV(with: [RecipeModelsDictionary]) {
        DispatchQueue.main.async {
            self.factory = RLFactory(collectionView: self.collectionView,
                                     arrayModelsDictionary: with,
                                     delegate: self.presenter)
        }
    }
}

// MARK: - UISearchBarFilterDelegate
extension RecipeListViewController: SearchBarFilterDelegate {
    func didTapFilterButton() {
        presenter.didTapFilterButton()
    }
}

// MARK: - UISearchBarDelegate - В Разработке
extension RecipeListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Пока не реализовано
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            // Пока не реализовано
        
    }
}
