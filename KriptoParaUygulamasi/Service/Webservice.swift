//
//  Webservice.swift
//  KriptoParaUygulamasi
//
//  Created by Atil Samancioglu on 21.10.2023.
//

import Foundation


enum CryptoError : Error {
    case serverError
    case decodingError
    case urlError
}

class Webservice {
    
    
    func downloadCurrencies(url: URL, completion: @escaping (Result<[Crypto],CryptoError>)->()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.serverError))
            } else if let data = data {
                
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                                
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    
    
}
