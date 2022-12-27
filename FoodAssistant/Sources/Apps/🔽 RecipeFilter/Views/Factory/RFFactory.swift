//
//  RFFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

protocol RecipeFilterSelectedIngredientsChangable {
    
    func changeSelectedIngredients(section: Int)
}

enum RFSectionType {
    case tag(_ HeaderType: HeaderType)
}

/// #Фабрика настройки коллекции модуля RecipeFilter
final class RFFactory {
    
    private let collectionView: UICollectionView
    private let dictModels: [RecipeFilterParameter: [TagModel]]
    private var cvAdapter: CVAdapter
    
    private weak var delegate: RecipeFilterPresentation?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(collectionView: UICollectionView,
         dictModels: [RecipeFilterParameter: [TagModel]],
         delegate: RecipeFilterPresentation?) {
        self.collectionView = collectionView
        self.dictModels = dictModels
        self.delegate = delegate
        
        cvAdapter = CVAdapter(collectionView: collectionView)
    }
    
    
    /// Настраивает табличное представление
    func setupCollectionView() {
        collectionView.dataSource = cvAdapter
        collectionView.delegate = cvAdapter
        
        /// Обновление данных в коллекции
        cvAdapter.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(tagModels: [TagModel],
                               type: RFSectionType) -> CVSectionBuilderProtocol {
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
    
    var builders: [CVSectionBuilderProtocol] {
        
        let action: ((Int) -> Void)? = { section in
            self.delegate?.changeSelectedIngredients(section: section)
        }
        let parameters = RecipeFilterParameter.allCases.sorted {$0.rawValue < $1.rawValue}
        
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
//        let builders = Constants.dict.map {
//            let headerModel = HeaderSectionModel(title: $0.key,
//                                                 firstImage: Icons.plusFill.image,
//                                                 action: action)
//            return createBuilder(titles: $0.value, type: .tag(.withButton(headerModel: headerModel)))
//        }
        
       return builders
    }
}

extension RFFactory {
    
    private struct Constants {
        static var dict: [String: [String]] = ["Animals Name" :
                                                ["Ant", "Bear", "Buffalo", "Butterfly", "Camel", "Cat", "Chameleon", "Chimpanzee", "Cow", "Crab", "Crocodile", "Deer", "Dog", "Donkey", "Elephant", "Fox", "Frog", "Goat", "Gorilla", "Hippopotamus", "Horse", "Jackal", "Lion", "Lizard", "Mongoose", "Monkey", "Mosquito", "Mouse", "Ox", "Pig", "Polar Bear", "Rabbit", "Rhinoceros", "Sheep", "Snail" ,"Snake", "Spider", "Squirrel", "Tiger", "Turtle", "Wolf", "Giraffe", "Zebra"],
                                               "Dry fruits" :
                                                ["Almond", "Anise", "Apricot", "Arrowroot", "Betel-nut", "Cantaloupe Seeds", "Cashew nut", "Chestnut", "Coconut", "Cudpahnut", "Currant", "Dates Dried", "Dates", "Fig", "Flax seeds", "Groundnuts", "Peanuts", "Lotus Seeds Pop", "Gorgon Nut Puffed Kernel", "Nut", "Walnuts", "Pine Nut", "Pistachio", "Prunes", "Pumpkin Seeds", "Saffron", "Sesame Seeds", "Sugar candy", "Watermelon Seeds"]
                                               
        ]
        
        static var dict2: [RecipeFilterParameter: [TagModel]] = [:]
                                                               
        
    }
    
    
}

struct TagModel {
    var title: String
    var isSelected: Bool
}

enum RecipeFilterParameter: Int, CaseIterable {
    case time, dishType, region, diet, calories, includeIngredients, excludeIngredients
}

extension RecipeFilterParameter {
    var title: String {
        switch self {
        case .time: return "Время"
        case .dishType: return "Тип блюда"
        case .region: return "Вид кухни"
        case .diet: return "Диета"
        case .calories: return "Каллории"
        case .includeIngredients: return "Включить ингредиенты"
        case .excludeIngredients: return "Исключить ингредиенты"
        }
    }
}
