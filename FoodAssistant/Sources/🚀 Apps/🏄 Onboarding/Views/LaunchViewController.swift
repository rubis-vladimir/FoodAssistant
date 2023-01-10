//
//  LaunchViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Варианты страницы для модуля Launch
enum LaunchPage: String, CaseIterable {
    case first = "firstImage"
    case second = "secondImage"
    case third = "thirdImage"
    case last = "lastImage"
}

extension LaunchPage {
    /// Текст заголовка
    var headerText: String {
        switch self {
        case .first: return "Добро пожаловать в FoodAssistant!".localize()
        case .second: return "Находите вкусное и полезное".localize()
        case .third: return "Сохраняйте рецепты".localize()
        case .last: return "Формируйте Шоп-лист".localize()
        }
    }
    /// Текст описания
    var descriptionText: String {
        switch self {
        case .first: return "Это приложение поможет вам в приготовлении вкусной и полезной еды по различным рецептам".localize()
        case .second: return "Вы быстро можете 🔍 найти сотни полезных и легких в приготовлении рецептов. А мы подскажем, что приготовить из ваших ингредиентов".localize()
        case .third: return "Понравившиеся рецепты вы можете добавить в ❤Избранные, чтобы они всегда были под рукой".localize()
        case .last: return "Выберите блюда для приготовления, укажите, какие ингредиенты из имеющихся вы будете использовать ✅ и получите актуальный Шоп-лист из выбранных блюд".localize()
        }
    }
}

/// #Контроллер представления для PageVC модуля Launch
final class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var customView: LaunchView = {
        let view = LaunchView()
        view.updateView(page: page)
        return view
    }()
    
    weak var delegate: LaunchViewDelegate?
    private var page: LaunchPage!
    
    // MARK: - Init & Override
    init(page: LaunchPage,
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
        customView.delegate = delegate
    }
}


