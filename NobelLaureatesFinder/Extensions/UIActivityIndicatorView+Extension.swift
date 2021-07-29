//
//  UIActivityIndicatorView+Extension.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import UIKit

extension UIActivityIndicatorView {
    var isLoading: Bool {
        get { isAnimating }
        set { newValue ? startAnimating() : stopAnimating() }
    }
}
