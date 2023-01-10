//
//  RFFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

/// #Протокол изменения выбранных ингредиентов
protocol SelectedIngredientsChangable {
    /// Изменить выбранные ингредиенты
    /// - Parameter section: номер секции
    func changeSelectedIngredients(section: Int)
}

/// #Варианты секции фильтра
enum RFSectionType {
    /// Секция с тэг-вью
    case tag(_ HeaderType: HeaderType)
}

/// #Фабрика настройки коллекции модуля RecipeFilter
final class RFFactory {
    
    private let collectionView: UICollectionView
    private let dictModels: [FilterParameters: [TagModel]]
    private var cvAdapter: CVAdapter
    
    private weak var delegate: RecipeFilterPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - collectionView: настраиваемая коллекция
    ///    - dictModels: словарь моделей параметров
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         dictModels: [FilterParameters: [TagModel]],
         delegate: RecipeFilterPresentation?) {
        self.collectionView = collectionView
        self.dictModels = dictModels
        self.delegate = delegate
        
        /// Определяет адаптер для коллекции
        cvAdapter = CVAdapter(collectionView: collectionView)
        
        setupCollectionView()
    }
    
    /// Настраивает коллекцию
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        
        /// Обновление данных в коллекции
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - tagModels: модели тэгов
    ///     - type: тип секции
    ///  - Returns: объект протокола строителя
    private func createBuilder(tagModels: [TagModel],
                               type: RFSectionType) -> CVSectionProtocol {
        switch type {
        case .tag(let headerType):
            return TagSectionConfigurator(header: headerType,
                                          tagModels: tagModels,
                                          delegate: delegate).configure(for: collectionView)
        }
    }
}

//MARK: - TVFactoryProtocol
extension RFFactory: CVFactoryProtocol {
    
    var builders: [CVSectionProtocol] {
        /// Устанавливаем действие
        let action: ((Int) -> Void)? = { section in
            self.delegate?.changeSelectedIngredients(section: section)
        }
        /// Определяем параметры по порядку
        let parameters = FilterParameters.allCases.sorted {$0.rawValue < $1.rawValue}
        
        /// Создаем билдеры в зависимаости от варианта параметров
        let builders = parameters.compactMap {
            if let models = dictModels[$0] {
                switch $0 {
                case .includeIngredients, .excludeIngredients:
                    let headerModel = HeaderSectionModel(title: $0.title,
                                                         firstImage: Icons.plusFill.image,
                                                         action: action)
                    return createBuilder(tagModels: models, type: .tag(.withButton(headerModel: headerModel)))
                    
                default:
                    return createBuilder(tagModels: models, type: .tag(.base(title: $0.title)))
                }
            } else {
                return nil
            }
        }
        
        return builders
    }
}



