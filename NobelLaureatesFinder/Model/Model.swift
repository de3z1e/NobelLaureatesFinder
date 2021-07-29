//
//  Model.swift
//  Nobel Laureates Finder
//
//  Created by Dimitry Zadorozny on 7/26/21.
//

import Foundation

/// Generic struct to fetch an array of `Item` objects that conform to `Decodable` and `Fetchable` protocols.
struct Model<Item: Decodable & Fetchable> {
    
    /**
     Asynchronously fetches data from network and passes result through completion handler on main thread.
     
     - parameter result: Returns `[Item]` or `ModelError` on main thread.
    */
    static func fetch(_ result: @escaping (Result<[Item], ModelError>) -> Void) {
        guard let url = Item.resourceUrl else { return result(.failure(.invalidURL)) }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    return result(.failure(.dataTaskError(error)))
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode != 200 {
                    return result(.failure(.invalidResponse(httpResponse.statusCode)))
                }
                
                guard let data = data else { return result(.failure(.invalidData)) }
                
                do {
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    guard items.isEmpty == false else {
                        let errorDescription = "The server response returned empty data."
                        return result(.failure(.emptyData(errorDescription)))
                    }
                    return result(.success(items))
                } catch {
                    return result(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
}
