//
//  RLSearchAdapter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 31.12.2022.
//

//
//import UIKit
//
//final class RLSearchAdapter: NSObject {
//    
//    weak var delegate: UISearchBarFilterDelegate?
//    
//}
//
//extension RLSearchAdapter: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let text = searchBar.text ?? ""
//        print(text)
////        fetchRecipesForSearchText(text.lowercased())
//        if isChangingFilters {
////            toggleFilterView()
//        }
//        isSearching = true
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if let text = searchBar.text, text.isEmpty && isSearching {
//            isSearching = false
//            print(text)
////            let topRow = IndexPath(row: 0, section: 0)
////            tableView.scrollToRow(at: topRow, at: .top, animated: false)
//        }
//    }
//}
//
//extension RLSearchAdapter: UISearchBarFilterDelegate {
//    func changeFilterView(isFilter: Bool) {
//        delegate?.changeFilterView(isFilter: isFilter)
//    }
//}
