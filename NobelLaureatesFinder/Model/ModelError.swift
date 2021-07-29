//
//  ModelError.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import Foundation

enum ModelError: Error {
    case invalidResponse(Int)
    case dataTaskError(Error)
    case decodingError(Error)
    case invalidData
    case invalidURL
    case emptyData(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse(let statusCode):
            return HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case .dataTaskError(let error):
            return error.localizedDescription
        case .decodingError(let decodingError):
            return decodingError.localizedDescription
        case .invalidData:
            return "Invalid data."
        case .invalidURL:
            return "Invalid URL."
        case .emptyData(let errorDescription):
            return errorDescription
        }
    }
}
