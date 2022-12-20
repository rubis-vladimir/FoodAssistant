//
//  LaunchViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол управления View-слоем модуля Launch
protocol LaunchViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// #Контроллер представления для PageVC модуля Launch
final class LaunchViewController: UIViewController {

    enum Page: String {
        case first = "firstImage"
        case second = "secondImageы"
        case third = "thirdImageы"
        case fourth = "fourthImageы"
    }
    
    private lazy var customView: LaunchView = {
        let view = LaunchView()
        return view
    }()
    
    weak var delegate: LaunchViewDelegate?
    private var page: Page!
    
    init(page: Page,
         delegate: LaunchViewDelegate?) {
        self.page = page
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .orange
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.backgroundGradientCover.frame = customView.backgroundImageView.bounds
    }
    
    private func configureView() {
        customView.backgroundImageView.image = UIImage(named: page.rawValue)
        customView.backgroundGradientCover.frame = customView.backgroundImageView.bounds
        customView.delegate = delegate
        switch page {
        case .first:
            customView.titleTextLabel.text = "Добро пожаловать в «FoodAssistant»!"
            customView.bodyTextLabel.text = "Это приложение поможет вам в приготовлении вкусной еды по различным рецептам"
        case .second:
            customView.titleTextLabel.text = ""
            customView.bodyTextLabel.text = "Ищите рецепты с ингредиентами, которые у вас есть, фильтруйте по питательным веществам, калориям или просто введите название блюда."
        case .third:
            customView.titleTextLabel.text = ""
            customView.bodyTextLabel.text = "Понравившиеся вам рецепты добавляйте в «Избранные», чтобы они всегда были под рукой"
        case .fourth:
            customView.titleTextLabel.text = ""
            customView.bodyTextLabel.text = "Используйте ингредиенты из вашего холодильника для составления актуального Шоп-листа из выбранных блюд"
        default:
            print("Undefined value")
        }
    }
}

// MARK: - LaunchViewable
extension LaunchViewController: LaunchViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
