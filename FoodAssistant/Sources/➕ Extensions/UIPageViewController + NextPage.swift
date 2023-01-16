//
//  UIPageViewController + NextPage.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.12.2022.
//

import UIKit

extension UIPageViewController {
    /// Переход на следующую страницу
    func goToNextPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
       setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
    }
}
