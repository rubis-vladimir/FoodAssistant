//
//  UserProfileViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Варианты запроса избранных рецептов
enum FavoriteRecipeQuery {
    /// Основной
    case base
    /// Запрос с поиском по названию
    case search(text: String)
}

/// #Протокол передачи UI-ивентов слою презентации
protocol UserProfilePresentation: RecipeRemovable,
                                  InBasketAdded,
                                  LayoutChangable,
                                  SelectedCellDelegate,
                                  SegmentedViewDelegate,
                                  ImagePresentation,
                                  CheckChangable,
                                  AnyObject {
    func didTapAddIngredientButton()
    func checkFlag(id: Int) -> Bool
    func fetchFavoriteRecipe(text: String)
    func getNewData()
}

/// #Протокол управления UI-ивентами сегмент-вью
protocol SegmentedViewDelegate {
    /// Ивент при выборе элемента
    ///  - Parameter index: индекс элемента
    func didSelectSegment(index: Int)
}

/// #Контроллер представления профиля пользователя
final class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    /// Презентер
    private let presenter: UserProfilePresentation
    /// Поисковый бар
    private let searchBar = UISearchBar()
    /// Фабрика настройки табличного представления
    private var factory: CVFactoryProtocol?
    /// Коллекция
    private var collectionView: UICollectionView!
    /// Таймер
    private var timer: Timer?
    
    private var searchBarShown: Bool = false
    
    // MARK: - Init & Override func
    init(presenter: UserProfilePresentation) {
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
        
        setupNavigationBar()
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let text = searchBar.text else { return }
        presenter.fetchFavoriteRecipe(text: text)
        presenter.getNewData()
    }
    
    
    // MARK: - Private func
    func setupElements() {
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.delegate = self
        
        let titleView = UPCustomSegmentedControl()
        titleView.delegate = presenter
        
        factory = UPFactory(collectionView: collectionView,
                            delegate: presenter,
                            orderSections: [.profile])
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleView.heightAnchor.constraint(equalToConstant: 42),
            
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
        ])
    }
    
    /// Возвращает настроенный `FlowLayout`
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding = AppConstants.padding
        layout.sectionInset = UIEdgeInsets(top: padding / 2,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
    
    func setupNavigationBar() {
        let settingsButton = createCustomBarButton(
            icon:.gearshape,
            selector: #selector(settingsButtonTapped)
        )
        
        navigationItem.title = "Мой помощник"
        navigationItem.rightBarButtonItems = [settingsButton]
    }
    
    /// Устанавливает/скрывает кнопку поиска
    private func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.leftBarButtonItem = createCustomBarButton(icon: Icons.magnifyingglass,
                                                                     selector: #selector(leftBarButtonPressed))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    /// Устанавливает/скрывает searchBar
    private func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        searchBar.becomeFirstResponder()
        navigationItem.titleView = shouldShow ? searchBar : nil
        searchBarShown = shouldShow
    }
    
    @objc private func leftBarButtonPressed() {
        search(shouldShow: true)
        
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func settingsButtonTapped() {
        
    }
    
    struct Constants {
        static let titleFont: UIFont? = UIFont(name: "MarkerFelt-Thin", size: 24)
        static let font: UIFont? = UIFont(name: "MarkerFelt-Thin", size: 18)
        static let textColor: UIColor = .white
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 2
        static let borderColor: CGColor = UIColor.white.cgColor
    }

}

// MARK: - UISearchBarDelegate
extension UserProfileViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: false) { [weak self] _ in
            print(searchText)
            self?.presenter.fetchFavoriteRecipe(text: searchText)
        }
    }
}


// MARK: - UserProfileViewable
extension UserProfileViewController: UserProfileViewable {
    
    func showAlert(completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void) {
        showAddIngredientAlert(completion: completion)
    }
    
    func reload(items: [IndexPath]) {
        collectionView.reloadItems(at: items)
    }
    
    func hideSearchBar(shouldHide: Bool) {
        if shouldHide {
            navigationItem.titleView = nil
            navigationItem.leftBarButtonItem = nil
        } else {
            searchBarShown ? search(shouldShow: true) : search(shouldShow: false)
        }
    }
    
    func updateCV(orderSection: [UPSectionType]) {
        
        
        DispatchQueue.main.async {
            self.factory = UPFactory(collectionView: self.collectionView,
                                     delegate: self.presenter,
                                     orderSections: orderSection)
        }
    }
    
    
    func showError() {
        
    }
}
