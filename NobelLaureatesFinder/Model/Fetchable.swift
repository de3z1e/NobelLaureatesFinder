//
//  Fetchable.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import Foundation

/// A type to define an object that can be used to make url requests.
protocol Fetchable {
    
    /// **Required.** Returns the url resource for URL requests.
    static var resourceUrl: URL? { get }
}
