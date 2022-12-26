//
//  RecipeListViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: LayoutChangable,
                                 SelectedCellDelegate,
                                 FavoriteChangable,
                                 InBasketAdded,
                                 ImagePresentation,
                                 AnyObject {
    
    func checkFavorite(id: Int) -> Bool
    func updateNewData()
    func didTapFilterButton(search: UISearchController)
}

/// #Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    // MARK: - Properties
    private var collectionView: UICollectionView?
    var searchController: RecipeListSearchController!
    private var timer: Timer?
    private var factory: RLFactory?
    
    private let presenter: RecipeListPresentation
    
    private var filterVC: UIViewController?
    
    private var isSearching: Bool = false
    private var isChangingFilters: Bool = false
    private var selectedSegment: Int = 0
    
    let navLabel: UILabel = {
        let label = UILabel()
        label.text = "FoodAssistant"
        label.font = Fonts.navTitle
        
        return label
    }()
    
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
        
        guard let navigationController = navigationController else { return }
        filterVC = RecipeFilterAssembly(navigationController: navigationController).assembly()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.updateNewData()
    }
    
    deinit {
        print("DEINIT \(self)")
    }
    
    func configureSearchController() {
        searchController = RecipeListSearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.filterDelegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Private func
    private func setupElements() {
        /// Настройка`navigationBar`
        navigationItem.titleView = navLabel
        navigationController?.navigationBar.shadowImage = UIImage()
        
        /// Настройка `searchBar`
//        let seacrhController = UISearchController(searchResultsController: nil)
//        seacrhController.hidesNavigationBarDuringPresentation = false
//        seacrhController.obscuresBackgroundDuringPresentation = false
//        seacrhController.searchBar.delegate = self
//
//        navigationItem.searchController = seacrhController
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        guard let collectionView = collectionView else { return }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        /// Настройка констрейнтов
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
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
    
    /// Рассчитывает размер Item
    private func calculateItemSize() -> CGSize {
        let padding: CGFloat = AppConstants.padding
        let itemPerRow: CGFloat = 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (view.bounds.width - paddingWidht) / itemPerRow
        return CGSize(width: availableWidth,
                      height: availableWidth + padding + 40)
    }
    
    func changeFilterButtonAppearance(with firstColor: UIColor, and secondColor: UIColor) {
        let button: UIButton = searchController.searchBar.filterButton
        // TODO: Animate here
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            button.tintColor = firstColor
            button.backgroundColor = secondColor
        }
        animator.startAnimation()
        
    }
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateCV(with: [RecipeModelsDictionary]) {
        
        guard let collectionView = collectionView else {return}
        DispatchQueue.main.async {
            self.factory = RLFactory(collectionView: collectionView,
                                     arrayModelsDictionary: with,
                                     delegate: self.presenter)
            self.factory?.setupCollectionView()
        }
    }
    
    func showError() {
        
    }
    
    func reload(items: [IndexPath]) {
        guard let collectionView = collectionView else {return}
        collectionView.reloadItems(at: items)
    }
    
}

extension RecipeListViewController: UISearchBarFilterDelegate {
    func toggleFilterView() {
        print("@@@@@ \(isChangingFilters) @@@@@ \( navigationController?.navigationBar.isTranslucent)")
        if isChangingFilters {
            changeFilterButtonAppearance(with: .black, and: Palette.bgColor.color)
//            navigationController?.navigationBar.isTranslucent = false
            navigationController?.popToRootViewController(animated: true)
        } else {
            changeFilterButtonAppearance(with: .white, and: Palette.darkColor.color)
//            navigationController?.navigationBar.isTranslucent = true
            presenter.didTapFilterButton(search: searchController)
        }
        
        
//        searchController.searchBar.setShowsScope(!isChangingFilters, animated: true)
        isChangingFilters.toggle()
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    // Presents searched recipes
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
//        fetchRecipesForSearchText(text.lowercased())
        if isChangingFilters {
            toggleFilterView()
        }
        isSearching = true
    }
    
    // Presents default recipes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Updates the table view only if the text field is empty and default recipes don't already present.
        if let text = searchBar.text, text.isEmpty && isSearching {
            isSearching = false
//            tableView?.reloadData()
//            let topRow = IndexPath(row: 0, section: 0)
//            tableView.scrollToRow(at: topRow, at: .top, animated: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedSegment = selectedScope
    }
}
