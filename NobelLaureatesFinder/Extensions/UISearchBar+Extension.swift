//
//  UISearchBar+Extension.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
}
