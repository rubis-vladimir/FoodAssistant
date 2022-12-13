//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации
protocol DetailInfoPresentation: AnyObject {
    /// Модель рецепта
    var model: RecipeProtocol { get }
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchRecipe(with imageName: String,
                     completion: @escaping (Data) -> Void)
    
    /// Запрошена загрузка изображения
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - size: размер изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchIngredients(with imageName: String,
                          size: ImageSize,
                          completion: @escaping (Data) -> Void)
    
    /// Нажата кнопка назад
    func didTapBackButton()
}

/// #Контроллер представления детальной информации
final class DetailInfoViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: CGRect.zero,
                                        style: .grouped)
    private let presenter: DetailInfoPresentation
    private var factory: DIFactory?
    
    // MARK: - Init
    init(presenter: DetailInfoPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset.top = -(navigationController?.navigationBar.frame.maxY ?? UIApplication.shared.statusBarFrame.height)
    }
    
    // MARK: - Private func
    private func setupNavigationBar() {
        let faivoriteRightButton = createCustomBarButton(
            icon: .heartLargeFill, 
            selector: #selector(changeFaivoriteButtonTapped)
        )
        
        let backLeftButton = createCustomBarButton(
            icon: .leftFill,
            selector: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [faivoriteRightButton]
        navigationItem.leftBarButtonItems = [backLeftButton]
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let model = presenter.model
        
        /// Создаем фабрику для конфигурации таблицы
        factory = DIFactory(tableView: tableView,
                            delegate: presenter,
                            scrollDelegate: self,
                            model: model)
        factory?.setupTableView()
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    /// Добавляет/убирает рецепт к любимым рецептам
    @objc private func changeFaivoriteButtonTapped() {
        print("changeFaivoriteButtonTapped")
    }
    
    /// Возврат к корневому экрану
    @objc private func backButtonTapped() {
        /// Убираем прозрачность navBar
        navigationController?.navigationBar.isTranslucent = false
        presenter.didTapBackButton()
    }
}

// MARK: - ScrollDelegate
extension DetailInfoViewController: ScrollDelegate {
    func scrollViewDidScroll(to offset: CGFloat) {
        let alpha = offset * 0.005
        navigationController?
            .navigationBar
            .setBackgroundImage(UIImage(named: "белый фон")?.alpha(alpha),
                                for: UIBarMetrics.default)
    }
}
