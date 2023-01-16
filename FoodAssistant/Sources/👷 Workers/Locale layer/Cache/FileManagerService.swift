//
//  FileManagerService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 16.12.2022.
//

import Foundation

/// #Менеджер сохранения файлов (Не используется / Как альтернатива ImageCache)
final class FileManagerService {

    static let shared = FileManagerService()

    private init() {}

    private var path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]

    /// Получаем файл из директории
    ///  - Parameter urlString: url строка
    private func getData(from urlString: String) -> Data? {
        guard let imageName = getImageName(from: urlString) else { return nil }
        let filePath = path.appendingPathComponent(imageName)

        do {
            return try Data(contentsOf: filePath)

        } catch {
            return nil
        }
    }

    /// Записываем данные изображения в директорию
    ///  - Parameters:
    ///   - imageData: данные изображения
    ///   - urlString: url строка
    private func write(_ imageData: Data?,
                       urlString: String) {
        guard let imageName = getImageName(from: urlString) else { return }
        let filePath = path.appendingPathComponent(imageName)

        do {
            try imageData?.write(to: filePath)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Получаем название изображения из urlString
    private func getImageName(from urlString: String) -> String? {
        let array = urlString.components(separatedBy: "/")
        return array.last
    }
}

// MARK: - ImageCacheProtocol
extension FileManagerService: ImageCacheProtocol {
    subscript(key: URL) -> Data? {
        get {
            return getData(from: key.absoluteString)
        }
        set {
            write(newValue, urlString: key.absoluteString)
        }
    }
}
