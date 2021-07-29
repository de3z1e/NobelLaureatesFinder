//
//  SearchViewController+UIPickerViewDelegates.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit

extension SearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        model.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        model.years[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.selectedYear = model.years[row]
    }
}
