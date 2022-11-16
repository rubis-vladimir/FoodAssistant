//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем
protocol BasketViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления корзины 
final class BasketViewController: UIViewController {

    private let presenter: BasketPresentation
    
    init(presenter: BasketPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        navigationController?.navigationBar.isHidden = false
        setupNavigitionBarViews()
    }
    
    /// Настраивает кастомный NavigitionBar
    private func setupNavigitionBarViews() {
        
        let saveRightButton = createCustomBarButton(
            imageName: "xmark",
            selector: #selector(saveAndExitRightButtonTapped)
        )
        let cancelLeftButton = createCustomBarButton(
            imageName: "xmark",
            selector: #selector(cancelLeftButtonTapped)
        )
        
        let label = UILabel()
        label.text = "Корзина"
        
        navigationItem.rightBarButtonItems = [saveRightButton]
        navigationItem.leftBarButtonItems = [cancelLeftButton]
        navigationItem.titleView = label
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func saveAndExitRightButtonTapped() {
        
    }
    
    /// Скрывает экран
    @objc private func cancelLeftButtonTapped() {
        dismissVC()
    }
    
    private func dismissVC() {
        guard let nc = navigationController else { return }
        nc.createCustomTransition(with: .fade)
        nc.navigationBar.isHidden = true
        nc.popViewController(animated: false)
    }
}

// MARK: - BasketViewable
extension BasketViewController: BasketViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
