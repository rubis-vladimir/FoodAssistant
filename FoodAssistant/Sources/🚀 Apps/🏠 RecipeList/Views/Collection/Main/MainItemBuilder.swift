//
//  MainItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Варианты Layout
enum LayoutType {
    /// Две в ряду
    case split2xN
    /// Одна в ряду
    case split1xN
}

/// #Строитель ячеек секции Main
final class MainItemBuilder {
    ///
    private var layoutType: LayoutType = .split2xN
    /// Вью модели рецептов
    private let models: [RecipeViewModel]
    /// Высота ячейки
    private let height: CGFloat

    weak var delegate: RecipeListPresentation?

    init(models: [RecipeViewModel],
         height: CGFloat,
         delegate: RecipeListPresentation?) {
        self.models = models
        self.height = height
        self.delegate = delegate

        signInNotification()
    }

    /// Рассчитывает размеры ячейки
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let itemPerRow: CGFloat = layoutType == .split1xN ? 1 : 2
        let availableWidth = AppConstants.calculateItemWidth(width: width,
                                                             itemPerRow: itemPerRow,
                                                             padding: AppConstants.padding)

        let availableHeight = layoutType == .split1xN ? height : availableWidth * 1.3
        return CGSize(width: availableWidth,
                      height: availableHeight)
    }

    /// Подписываем на класс на нотификацию
    private func signInNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLayoutType),
                                               name: NSNotification.Name("changeLayoutType"),
                                               object: nil)
    }

    /// Изменение `Layout` секции
    @objc private func changeLayoutType() {
        layoutType = layoutType == .split2xN ? .split1xN : .split2xN
    }
}

// MARK: - CVItemBuilderProtocol
extension MainItemBuilder: CVSelectableItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(FirstRecipeCell.self)
        collectionView.register(SecondRecipeCell.self)
    }

    func itemCount() -> Int { models.count }

    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }

    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        /// Получаем модель для ячейки
        let model = models[indexPath.item]
        /// Получаем вариант исполнения ячейки в зависимости от типа `Layout`
        let typeCell = layoutType == .split2xN ? FirstRecipeCell.self : SecondRecipeCell.self

        /// Создаем и настраиваем ячейку
        let cell = collectionView.dequeueReusableCell(typeCell,
                                                      indexPath: indexPath)
        cell.basketDelegate = delegate
        cell.favoriteDelegate = delegate

        let favorite = delegate?.checkFavorite(id: model.id) ?? false
        cell.configure(with: model, type: .favorite(favorite))

        if let imageName = model.imageName {
            /// Загрузка изображения
            delegate?.fetchImage(imageName,
                                 type: .recipe) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(data: imageData)
                }
            }
        }
        return cell
    }

    func didSelectItem(indexPath: IndexPath) {
        let model = models[indexPath.item]
        delegate?.didSelectItem(id: model.id)
    }
}
