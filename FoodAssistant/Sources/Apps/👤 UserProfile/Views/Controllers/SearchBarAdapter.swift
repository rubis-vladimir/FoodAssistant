////
////  SearchBarAdapter.swift
////  FoodAssistant
////
////  Created by Владимир Рубис on 29.12.2022.
////
//
//import UIKit
//
//final class SearchBarAdapter {
//    
//    weak var searchBar: UISearchBar?
//    
//    
//    /// Устанавливает/скрывает кнопку поиска
//    private func showSearchBarButton(shouldShow: Bool) {
//        if shouldShow {
//            navigationItem.leftBarButtonItem = createCustomBarButton(icon: Icons.magnifyingglass,
//                                                                     selector: #selector(leftBarButtonPressed))
//        } else {
//            navigationItem.leftBarButtonItem = nil
//        }
//    }
//    
//    /// Устанавливает/скрывает searchBar
//    private func search(shouldShow: Bool) {
//        showSearchBarButton(shouldShow: !shouldShow)
//        searchBar.showsCancelButton = shouldShow
//        searchBar.becomeFirstResponder()
//        navigationItem.titleView = shouldShow ? searchBar : nil
//        searchBarShown = shouldShow
//    }
//    
//    @objc private func leftBarButtonPressed() {
//        search(shouldShow: true)
//        
//    }
//}
//
//
//// MARK: - UISearchBarDelegate
//extension SearchBarAdapter: UISearchBarDelegate {
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        search(shouldShow: false)
//        
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
//                                     repeats: false) { [weak self] _ in
//            print(searchText)
//            self?.presenter.fetchFavoriteRecipe(text: searchText)
//        }
//    }
//}
