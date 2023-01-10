//
//  TVAdapter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Протокол делегата прокрутки экрана
protocol ScrollDelegate: AnyObject {
    /// Отслеживает перемещение scrollView
    /// - Parameter offset: перемещение Y
    func scrollViewDidScroll(to offset: CGFloat)
}

/// #Адаптер для TableView
final class TVAdapter: NSObject {
    
    private let tableView: UITableView
    private weak var scrollDelegate: ScrollDelegate?
    
    private var builders: [TVSectionProtocol] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView,
         scrollDelegate: ScrollDelegate?) {
        self.tableView = tableView
        self.scrollDelegate = scrollDelegate
    }
    
    func configure(with builders: [TVSectionProtocol]) {
        self.builders = builders
    }
}

// MARK: - UITableViewDataSource
extension TVAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        builders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        builders[section].cellBuilder.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        builders[indexPath.section].cellBuilder.cellAt(indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        builders[section].titleHeader
    }
}

// MARK: - UITableViewDelegate
extension TVAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        builders[indexPath.section].cellBuilder.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = builders[section].titleHeader
            headerView.textLabel?.font = Fonts.subtitle
            headerView.contentView.backgroundColor = .clear
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(to: scrollView.contentOffset.y)
    }
}


