//
//  ImageCacheService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import Foundation

/// Протокол кеширования изображений в памяти
protocol ImageCacheProtocol {
    /// Доступ к значению, связанному с  ключом, для чтения и записи
    subscript(_ key: URL) -> Data? { get set }
}

/// #Сервис кеширования изображений
final class ImageCacheService {

    private lazy var cache: LRUCache<URL, Data> = {
        let cache = LRUCache<URL, Data>()
        cache.countLimit = config.countLimit
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 100,
                                          memoryLimit: 1024 * 1024 * 100)
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

// MARK: - ImageCacheProtocol
extension ImageCacheService: ImageCacheProtocol {
    
    subscript(_ key: URL) -> Data? {
        get {
            cache.value(forKey: key)
        }
        set {
            cache.setValue(newValue, forKey: key)
        }
    }
}
