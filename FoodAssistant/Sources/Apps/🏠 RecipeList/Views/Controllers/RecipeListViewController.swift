//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Типы моделей данных рецептов
enum RLModelType {
    /// Рекомендованные
    case recommended
    /// Основные
    case main
}

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: LayoutChangable,
                                 SelectedCellDelegate,
                                 EventsCellDelegate,
                                 AnyObject {
    /// Получить изображение
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImage(with imageName: String,
                    completion: @escaping (Data) -> Void)
}

/// #Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private var factory: RLFactory?
    
    private let presenter: RecipeListPresentation
    
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
        
        setupElements()
    }
    
    // MARK: - Private func
    private func setupElements() {
        /// Настройка`navigationBar`
        navigationItem.title = "Food Assistant"
        navigationController?.navigationBar.shadowImage = UIImage()
        
        /// Настройка `searchBar`
        let seacrhController = UISearchController(searchResultsController: nil)
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
        
        navigationItem.searchController = seacrhController
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
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
}

// MARK: - UISearchBarDelegate
extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI(with type: RLBuildType) {
        DispatchQueue.main.async {
            self.factory = RLFactory(collectionView: self.collectionView,
                                buildType: type,
                                delegate: self.presenter)
            self.factory?.setupCollectionView()
        }
    }
    
    func showError() {
        
    }
    
    func reloadSection(_ section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
}
