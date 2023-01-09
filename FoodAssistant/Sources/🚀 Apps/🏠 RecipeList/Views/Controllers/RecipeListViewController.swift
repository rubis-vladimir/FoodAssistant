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
    /// - Parameters:
    ///  - flag: флаг
    ///  - search: поисковой контроллер
    func didTapFilterButton(_ flag: Bool)
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
    private let searchController: RecipeListSearchController
    
    private var isSearching: Bool = false
    private var isChangingFilters: Bool = false
    private var selectedSegment: Int = 0
    
    private lazy var navLabel = createNavTitle(title: "FoodAssistant")
    
    // MARK: - Init & ViewDidLoad
    init(presenter: RecipeListPresentation,
         searchController: RecipeListSearchController) {
        self.presenter = presenter
        
        
            self.searchController = searchController
       
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
        searchController.searchBar.delegate = self
        searchController.searchBar.filterDelegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        if #available(iOS 13.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    // MARK: - Private func
    private func setupElements() {
        navigationItem.titleView = navLabel
        navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        /// Настройка констрейнтов
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        searchController.searchBar.isFilter = false
        return searchController.searchBar.text
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
    func changeFilterView(isFilter: Bool) {
        presenter.didTapFilterButton(isFilter)
    }
}

// MARK: - UISearchBarDelegate - В Разработке
extension RecipeListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = true
        // Пока не реализовано
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text, text.isEmpty && isSearching {
            isSearching = false
            
            // Пока не реализовано
        }
    }
}
