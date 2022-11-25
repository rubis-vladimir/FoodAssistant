//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    private let presenter: RecipeListPresentation
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private var factory: RLFactory?
    
    init(presenter: RecipeListPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupElements()
    }
    
    private func setupElements() {
        /// `Navigation Bar` Setup
        navigationItem.title = "Food Assistant"
        
        let rightButton = createCustomBarButton(imageName: Icons.split2x2.rawValue, selector: #selector(clickChangeViewButton))
        navigationItem.rightBarButtonItem = rightButton
        
        /// `seacrhController` settings
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
        
        /// `CollectionView` settings
        let newFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.bounds.height ?? 0) + 13)
        collectionView = UICollectionView(frame: newFrame,
                                          collectionViewLayout: getFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        //// ПЕРЕНОС
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(RecipeCell.self)
//        collectionView.register(RecommendedViewCell.self)
//        collectionView.register(CustomSectionHeader.self, kind: UICollectionView.elementKindSectionHeader)
        
        /// Adding elements to the screen
        view.addSubview(collectionView)
        
        /// Setting up the location of elements on the screen
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
//        NSLayoutConstraint.activate([
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
    }
    
    
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
//        layout.itemSize = calculateItemSize()
        return layout
    }
    
    /// Рассчитывает размер Item
    private func calculateItemSize() -> CGSize {
        let padding: CGFloat = 16
        let itemPerRow: CGFloat = 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (view.bounds.width - paddingWidht) / itemPerRow
        return CGSize(width: availableWidth,
                      height: availableWidth + padding + 40)
        
//
//        let padding: CGFloat = 16
//        let itemPerRow: CGFloat = 1
//        let paddingWidht = padding * (itemPerRow + 1)
//        let availableWidth = view.bounds.width * 0.8 - paddingWidht
//        return CGSize(width: availableWidth,
//                      height: availableWidth * 1.5)
//
    }
    
    @objc func clickChangeViewButton() {
        
    }
}

//extension RecipeListViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        2
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
//            return presenter.recipeCellModels.count
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(RecommendedViewCell.self, indexPath: indexPath)
//            cell.delegate = presenter
//            cell.configure(with: presenter.recipeCellModels)
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(RecipeCell.self, indexPath: indexPath)
//            let model = presenter.recipeCellModels[indexPath.row]
//            cell.delegate = presenter
//            cell.configure(with: model)
//            if let imageName = model.imageName {
//                presenter.fetchImage(with: imageName) { imageData in
//                    DispatchQueue.main.async {
//                        //                    let updateCell = collectionView.cellForItem(at: indexPath)
//                        //                    if updateCell != nil {
//                        cell.updateRecipeImage(data: imageData)
//                        //                    }
//                    }
//                }
//            }
//            return cell
//        }
//
//    }
//}

//extension RecipeListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch indexPath.section {
//        case 0: return CGSize(width: view.frame.width, height: 300)
//        default: return calculateItemSize()
//        }
//    }
//}


//extension RecipeListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//
//            let headerView = collectionView.dequeueReusableView(CustomSectionHeader.self,
//                                                                kind: kind,
//                                                                indexPath: indexPath)
//            switch indexPath.section {
//            case 0: headerView.configure(title: "Рекомендации",
//                                         selector: #selector(changeLayoutButtonTapped))
//            default: headerView.configure(title: "Популярные блюда",
//                                          selector: #selector(changeLayoutButtonTapped))
//            }
//
//            return headerView
//        default:
//            assert(false, "Invalid element type")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: collectionView.frame.width, height: 45)
//    }
//
//    @objc private func changeLayoutButtonTapped() {
//        print("changeLayoutButtonTapped")
//    }
//}

extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI() {
        DispatchQueue.main.async {
            let models = self.presenter.recipeCellModels
            self.factory = RLFactory(collectionView: self.collectionView,
                                buildType: .main(first: models,
                                                 second: models),
                                delegate: self.presenter)
            self.factory?.setupCollectionView()
        }
    }
    
    
    func showError() {
        
    }
}
