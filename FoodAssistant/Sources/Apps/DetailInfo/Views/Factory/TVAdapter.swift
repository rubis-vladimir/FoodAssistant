//
//  TVAdapter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Адаптер для TableView
final class TVAdapter: NSObject {
    
    private let tableView: UITableView
    private var builders: [TVSectionBuilderProtocol] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func configure(with builders: [TVSectionBuilderProtocol]) {
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
        print(scrollView.contentOffset)
    }
}
