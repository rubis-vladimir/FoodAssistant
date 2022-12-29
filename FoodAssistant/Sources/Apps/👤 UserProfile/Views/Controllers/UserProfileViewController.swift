//
//  UserProfileViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации
protocol UserProfilePresentation: DeleteTapable,
                                  InBasketTapable,
                                  CellSelectable,
                                  SegmentedViewDelegate,
                                  ImagePresentation,
                                  CheckChangable,
                                  ViewAppearable,
                                  AnyObject {
    /// Была нажата кнопка добавления ингредиента
    func didTapAddIngredientButton()
    /// Ивент после ввода текста в поисковой бар
    func textEntered(_ text: String)
    /// Проверить флаг ингредиента
    /// - Parameter id: идентификатор
    func checkFlag(id: Int) -> Bool
}



/// #Контроллер представления профиля пользователя
final class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    /// Презентер
    private let presenter: UserProfilePresentation
    /// Поисковый бар
    private let searchBar = UISearchBar()
    /// Сегмент вью
    private let segmentView = CustomSegmentedControl()
    /// Фабрика настройки табличного представления
    private var factory: CVFactoryProtocol?
    /// Таймер
    private var timer: Timer?
    /// Флаг отображения поискового бара
    private var searchBarShown: Bool = false
    /// Коллекция
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: AppConstants.getFlowLayout())
    
    // MARK: - Init & Override func
    init(presenter: UserProfilePresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupElements()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewAppeared()
        
        guard let text = searchBar.text else { return }
        presenter.textEntered(text)
    }
    
    // MARK: - Private func
    private func setupNavigationBar() {
        navigationItem.title = "Мой помощник"
    }
    
    func setupElements() {
        view.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.delegate = self
        segmentView.delegate = presenter
        
        factory = UPFactory(collectionView: collectionView,
                            delegate: presenter,
                            orderSections: [.profile])
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(segmentView)
        
        NSLayoutConstraint.activate([
            segmentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            segmentView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 5),
            segmentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            segmentView.heightAnchor.constraint(equalToConstant: 42),
            
            collectionView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
        ])
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
            self?.presenter.textEntered(searchText)
        }
    }
}


// MARK: - UserProfileViewable
extension UserProfileViewController: UserProfileViewable {
    
    func showAlert(completion: @escaping (Result<IngredientViewModel, NetworkFetcherError>) -> Void) {
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
    
    func show(error: Error) {
        
    }
}
