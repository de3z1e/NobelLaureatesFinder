//
//  UIStoryboard+Extension.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var locationSearchResultsController: LocationSearchResultsController {
        main.instantiateViewController(identifier: "LocationSearchResultsController") as LocationSearchResultsController
    }

    static var laureatesNavigationController: LaureatesNavigationController {
        main.instantiateViewController(identifier: "LaureatesNavigationController") as LaureatesNavigationController
    }
}
