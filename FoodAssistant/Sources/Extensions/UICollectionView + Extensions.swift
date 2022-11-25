//
//  UICollectionView + Extensions.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

extension UICollectionView {
    
    /// Регистрирует ячейку коллекции
    func register<T: UICollectionViewCell>(_ classType: T.Type) {
        let string = String(describing: classType)
        register(classType,
                 forCellWithReuseIdentifier: string)
    }
    
    /// Регистрирует вью коллекции
    func register<T: UICollectionReusableView>(_ classType: T.Type,
                                               kind: String) {
        let string = String(describing: classType)
        register(classType,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: string)
    }
    
    /// Переиспользование ячейки коллекции
    func dequeueReusableCell<T: UICollectionViewCell>(_ classType: T.Type,
                                                      indexPath: IndexPath) -> T {
        let string = String(describing: classType)
        return dequeueReusableCell(withReuseIdentifier: string,
                                   for: indexPath) as! T
    }
    
    /// Переиспользование вью коллекции
    func dequeueReusableView<T: UICollectionReusableView>(_ classType: T.Type,
                                                          kind: String,
                                                      indexPath: IndexPath) -> T {
        let string = String(describing: classType)
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: string,
                                                for: indexPath) as! T
    }
    
    
}
