//
//  SearchViewController.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

class SearchViewController: UIViewController, UISearchControllerDelegate {
        
    let model = LaureatesViewModel.shared
    let locationManager = CLLocationManager()
    
    private let backgroundViewHostingController = UIHostingController(rootView: BackgroundWavesView())
    private let blurOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private var searchController: UISearchController?
    private var subscribers = Set<AnyCancellable>()
    
    @IBOutlet weak var startSearchButton: BorderedButton!
    @IBAction func startSearchButtonAction(_ sender: BorderedButton) {
        model.sortLaureates()
        let nobelPrizeWinnersNavigationController = UIStoryboard.nobelPrizeWinnersNavigationController
        present(nobelPrizeWinnersNavigationController, animated: true)
    }
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBAction func locationSearchButtonTouchDown(_ sender: UIButton) { locationSearchBar.alpha = 0.5 }
    @IBAction func locationSearchButtonTouchCancel(_ sender: UIButton) { locationSearchBar.alpha = 1.0 }
    @IBAction func locationSearchButtonAction(_ sender: UIButton) {
        configureSearchController()
        guard let searchController = searchController else {
            print("Search controller returned nil")
            return
        }
        present(searchController, animated: true)
        willPresentSearchController(searchController)
    }
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    @IBOutlet weak var yearPicker: UIPickerView! {
        didSet {
            yearPicker.dataSource = self
            yearPicker.delegate = self
        }
    }
    
    @IBOutlet weak var controlsContainerView: UIView! {
        didSet {
            controlsContainerView.layer.cornerRadius = 10
            controlsContainerView.clipsToBounds = true
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            blurView.frame = controlsContainerView.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            controlsContainerView.insertSubview(blurView, at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocationAuthorization()
        configureBackgroundView()
        configureBlurOverlay()
        configureSubscribers()
        
        locationSearchBar.textField?.clearButtonMode = .never
    }
    
    private func configureSubscribers() {
        model.$selectedLocation.sink { [weak self] mapItem in
            self?.locationSearchBar.text = mapItem?.name
            self?.startSearchButton.isEnabled = mapItem != nil && self?.model.isLoading == false
        }.store(in: &subscribers)
        
        model.$isLoading.sink { [weak self] willLoad in
            self?.startSearchButton.setTitle(willLoad ? "" : "Start Search", for: .normal)
            self?.loadingActivityIndicator.isLoading = willLoad
            self?.startSearchButton.isEnabled = !willLoad && self?.model.selectedLocation != nil
        }.store(in: &subscribers)
        
        model.$error.sink { [weak self] modelViewError in
            if let modelViewError = modelViewError {
                self?.displayError(modelViewError)
            }
        }.store(in: &subscribers)
    }
    
    private func configureBackgroundView() {
        backgroundViewHostingController.view.frame = view.bounds
        backgroundViewHostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundViewHostingController.view, at: 0)
    }
    
    private func configureSearchController() {
        let locationSearchResultsController = UIStoryboard.locationSearchResultsController
        searchController = UISearchController(searchResultsController: locationSearchResultsController)
        searchController?.showsSearchResultsController = true
        searchController?.delegate = self
        searchController?.searchResultsUpdater = locationSearchResultsController
        searchController?.searchBar.isTranslucent = false
        searchController?.searchBar.placeholder = "Search Locations"
        searchController?.definesPresentationContext = true
    }
    
    private func removeSearchController() {
        searchController = nil
    }
    
    private func configureBlurOverlay() {
        blurOverlay.frame = view.bounds
        blurOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurOverlay.alpha = 0
        view.addSubview(blurOverlay)
    }
    
    private func displayError(_ error: ModelViewError) {
        let alertController = UIAlertController(title: error.title, message: error.localizedDescription, preferredStyle: .alert)
        if case .updateError(_) = error {
            alertController.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.model.updateModel()
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // Search Controller delegate methods
    func willPresentSearchController(_ searchController: UISearchController) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: []) { [weak self] in
            self?.blurOverlay.alpha = 1.0
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: []) { [weak self] in
            self?.blurOverlay.alpha = 0.0
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        removeSearchController()
    }
}
