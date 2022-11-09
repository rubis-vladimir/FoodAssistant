//
//  String + URL.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

extension String {
    
    /// Получить URL из строки
    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw DataFetcherError.wrongUrl }
        return url
    }
    

}
