//
//  ModelViewError.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/29/21.
//

import Foundation

enum ModelViewError: Error {
    case updateError(ModelError)
    case searchLocationError(Error)
    case sortError(String)
    
    var title: String {
        switch self {
        case .updateError(_): return "Could not fetch laureates from database."
        case .searchLocationError(_): return "Could not find a location."
        case .sortError(_): return "Error sorting laureates."
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .updateError(let modelError): return modelError.localizedDescription
        case .searchLocationError(let error): return error.localizedDescription
        case .sortError(let errorDescription): return errorDescription
        }
    }
}
