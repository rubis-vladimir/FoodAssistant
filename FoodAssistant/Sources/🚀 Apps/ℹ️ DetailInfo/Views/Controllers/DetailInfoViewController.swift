//
//  DetailInfoViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации
protocol DetailInfoPresentation: ImagePresentation,
                                 BackTapable,
                                 TimerTapable,
                                 AnyObject {
    /// Модель рецепта
    var recipe: RecipeProtocol { get }
    /// Нажата кнопка изменения флага избранного рецепта
    func didTapChangeFavoriteButton(_ flag: Bool)
    /// Проверить ингредиент
    func checkFor(ingredient: IngredientViewModel) -> Bool
    /// Нажата кнопка запустить таймер
    func didTapStartTimer(step: Int, count: Int)
}

/// #Контроллер представления детальной информации рецепта
final class DetailInfoViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView(frame: CGRect.zero,
                                        style: .grouped)
    private let presenter: DetailInfoPresentation
    private var factory: DIFactory?

    private var isFavorite: Bool = false {
        didSet {
            faivoriteRightButton?.customView?.tintColor = isFavorite ? Palette.darkColor.color : .black
            presenter.didTapChangeFavoriteButton(isFavorite)
        }
    }

    private var faivoriteRightButton: UIBarButtonItem?

    // MARK: - Init & Override func
    init(presenter: DetailInfoPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        faivoriteRightButton = createCustomBarButton(
            icon: .heartLargeFill,
            selector: #selector(changeFaivoriteButtonTapped)
        )

        let backLeftButton = createCustomBarButton(
            icon: .leftFill,
            selector: #selector(backButtonTapped)
        )

        if let button = faivoriteRightButton {
            navigationItem.rightBarButtonItems = [button]
        }
        navigationItem.leftBarButtonItems = [backLeftButton]
    }

    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let recipe = presenter.recipe
        isFavorite = recipe.isFavorite

        /// Создаем фабрику для конфигурации таблицы
        factory = DIFactory(tableView: tableView,
                            delegate: presenter,
                            scrollDelegate: self,
                            recipe: recipe)
    }

    private func setupConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// Изменяет флаг избранного рецепта
    @objc private func changeFaivoriteButtonTapped() {
        isFavorite.toggle()
    }

    /// Возврат к корневому экрану
    @objc private func backButtonTapped() {
        presenter.didTapBackButton()
    }
}

// MARK: - DetailInfoViewable
extension DetailInfoViewController: DetailInfoViewable {

    func showTimer(step: Int) {
        showSetupTimerAlert(title: "Timer".localize()) { [weak self] count in
            self?.presenter.didTapStartTimer(step: step,
                                             count: count)
        }
    }
}

// MARK: - ScrollDelegate
extension DetailInfoViewController: ScrollDelegate {
    func scrollViewDidScroll(to offset: CGFloat) {
        /// Меняем прозрачность изображения-подложки в NavBar
        let alpha = offset * 0.005
        navigationController?
            .navigationBar
            .setBackgroundImage(UIImage(named: "белый фон")?.alpha(alpha),
                                for: UIBarMetrics.default)
    }
}
