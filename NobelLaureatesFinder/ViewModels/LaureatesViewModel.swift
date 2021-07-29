//
//  LaureatesViewModel.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import UIKit
import CoreLocation
import MapKit
import Combine

class LaureatesViewModel: ObservableObject {
    
    /// Singleton instance to provide a shared view model object across all view controllers.
    static let shared = LaureatesViewModel()
    
    let years: [Int32] = Array(1900...2020).reversed()
    @Published var selectedYear: Int32 = 2020
    @Published var selectedLocation: MKMapItem?
    
    @Published private(set) var laureates: [Laureate] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: ModelViewError?
    
    private var isModelUpdateLoading = false {
        didSet {
            isLoading = isModelUpdateLoading || isLocationSearchLoading
        }
    }
    private var isLocationSearchLoading = false {
        didSet {
            isLoading = isModelUpdateLoading || isLocationSearchLoading
        }
    }
    
    private let locationSearchRequest = MKLocalSearch.Request()
    private var locationSearch: MKLocalSearch? {
        willSet {
            // Clear previous location and cancel any currently running searches.
            selectedLocation = nil
            locationSearch?.cancel()
        }
    }
    
    init() {
        updateModel()
    }
    
    func updateModel() {
        error = nil
        isModelUpdateLoading = true
        Model<Laureate>.fetch { [weak self] result in
            self?.isModelUpdateLoading = false
            switch result {
            case .success(let laureates):
                self?.laureates = laureates
            case .failure(let modelError):
                self?.error = .updateError(modelError)
            }
        }
    }
    
    func startLocationSearch(for query: String) {
        error = nil
        isLocationSearchLoading = true
        locationSearchRequest.naturalLanguageQuery = query
        locationSearch = MKLocalSearch(request: locationSearchRequest)
        locationSearch?.start(completionHandler: { [weak self] response, error in
            self?.isLocationSearchLoading = false
            if let error = error {
                self?.error = .searchLocationError(error)
            }
            self?.selectedLocation = response?.mapItems.first
        })
    }
    
    /// Uses the Swift Standard Library sort function which has a time complexity of O(*n* log *n*)
    func sortLaureates() {
        error = nil
        guard laureates.isEmpty == false else {
            let errorDescription = "Laureates data is empty."
            error = .updateError(.emptyData(errorDescription))
            return
        }
        guard let coordinates = selectedLocation?.placemark.coordinate else {
            let errorDescription = "No location selected to perform sort."
            error = .sortError(errorDescription)
            return
        }
        let currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        laureates.sort {
            let l1Cost = costFunction(currentLocation: currentLocation, currentYear: selectedYear, targetLocation: $0.location, targetYear: $0.year)
            let l2Cost = costFunction(currentLocation: currentLocation, currentYear: selectedYear, targetLocation: $1.location, targetYear: $1.year)
            return l1Cost < l2Cost
        }
    }
    
    /// Computes the cost of traveling through space and time from the current location/year to the target location/year.
    private func costFunction(currentLocation: CLLocation, currentYear: Int32, targetLocation: CLLocation, targetYear: Int32) -> Int32 {
        let spaceCost = targetLocation.distance(from: currentLocation)
        let timeCost = abs(targetYear - currentYear) * 10000
        return Int32(spaceCost) + timeCost
    }
    
}
