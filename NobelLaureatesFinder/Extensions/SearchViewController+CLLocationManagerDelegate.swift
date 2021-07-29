//
//  SearchViewController+CLLocationManagerDelegate.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/29/21.
//

import UIKit
import MapKit

extension SearchViewController: CLLocationManagerDelegate {
    func requestLocationAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Restricted location services")
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not get current location with error: \(error)")
    }
}
