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
    
    func checkFavorite(id: Int) -> Bool
    func updateNewData()
    func didTapFilterButton(_ flag: Bool, search: UISearchController)
}

/// #Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    // MARK: - Properties
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                                        collectionViewLayout: AppConstants.getFlowLayout())
    var searchController: RecipeListSearchController!
    private var timer: Timer?
    private var factory: RLFactory?
    
    private let presenter: RecipeListPresentation
    
    private var isSearching: Bool = false
    private var isChangingFilters: Bool = false
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
        searchController = RecipeListSearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.filterDelegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
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
    func updateItems(indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func updateFilterButton() {
        searchController.searchBar.isFilter = false
    }
    
    func updateCV(with: [RecipeModelsDictionary]) {
        DispatchQueue.main.async {
            self.factory = RLFactory(collectionView: self.collectionView,
                                     arrayModelsDictionary: with,
                                     delegate: self.presenter)
        }
    }
    
    func showError(_ error: Error) {
        
    }
}

extension RecipeListViewController: UISearchBarFilterDelegate {
    func changeFilterView(isFilter: Bool) {
//        navigationController?.hidesBottomBarWhenPushed = true
        presenter.didTapFilterButton(isFilter,
                                     search: searchController)
    }
}

extension RecipeListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
//        fetchRecipesForSearchText(text.lowercased())
        if isChangingFilters {
//            toggleFilterView()
        }
        isSearching = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text, text.isEmpty && isSearching {
            isSearching = false
//            let topRow = IndexPath(row: 0, section: 0)
//            tableView.scrollToRow(at: topRow, at: .top, animated: false)
        }
    }
}
