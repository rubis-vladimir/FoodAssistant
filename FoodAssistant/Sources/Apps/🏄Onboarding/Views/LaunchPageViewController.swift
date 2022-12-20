//
//  LaunchPageViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.12.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации
protocol LaunchPresentation: LaunchViewDelegate {
}

/// #Контроллер представления Онбординг-экрана
class LaunchPageViewController: UIPageViewController {
    
    private var pages: [UIViewController] = []
    private var currentPageIndex: Int = 0
    
    private let presenter: LaunchPresentation
    
    // MARK: - Init & ViewDidLoad
    init(presenter: LaunchPresentation) {
        self.presenter = presenter
        super.init(transitionStyle: UIPageViewController.TransitionStyle.pageCurl, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllers()
        setViewControllers([pages[0]], direction: .forward, animated: true)
        delegate = self
        dataSource = self
    }
}

// MARK: - Internal
private extension LaunchPageViewController {
    func addViewControllers() {
        pages.append(LaunchViewController(page: .first, delegate: presenter))
        pages.append(LaunchViewController(page: .second, delegate: presenter))
        pages.append(LaunchViewController(page: .third, delegate: presenter))
        pages.append(LaunchViewController(page: .fourth, delegate: presenter))
    }
}

// MARK: - UIPageViewControllerDelegate
extension LaunchPageViewController: UIPageViewControllerDelegate {
    
}

// MARK: - UIPageViewControllerDataSource
extension LaunchPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        currentPageIndex = index - 1
        return pages[currentPageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count-1 else {
            return nil
        }
        currentPageIndex = index + 1
        return pages[currentPageIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentPageIndex
    }
}

extension LaunchPageViewController: LaunchViewable {
    func updateUI() {
        
    }
    
    func showError() {
        
    }
    
    
}
