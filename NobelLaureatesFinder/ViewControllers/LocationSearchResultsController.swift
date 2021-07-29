//
//  SearchResultsController.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit
import MapKit

class LocationSearchResultsController: UITableViewController {

    static let cellIdentifier = "SearchResultCell"

    private let model = LaureatesViewModel.shared

    private typealias DataSource = UITableViewDiffableDataSource<Section, MKLocalSearchCompletion>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MKLocalSearchCompletion>
    private lazy var dataSource: DataSource = configureDataSource()

    private var searchCompleter: MKLocalSearchCompleter?

    private enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchCompleter()
        tableView.dataSource = dataSource
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
    }

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { [weak self] _, _, item in
            let cell = self?.tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier)
            cell?.textLabel?.text = item.title
            cell?.detailTextLabel?.text = item.subtitle
            return cell
        }
        dataSource.defaultRowAnimation = .none
        return dataSource
    }

    private func applySnapshot(_ items: [MKLocalSearchCompletion]?, animatingDifferences: Bool = false, completion: (() -> Void)? = nil) {
        guard let items = items else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completionItem = dataSource.snapshot().itemIdentifiers(inSection: .main)[indexPath.row]
        var query = completionItem.title
        let subtitle = completionItem.subtitle
        if !subtitle.isEmpty {
            query += " \(subtitle)"
        }
        model.startLocationSearch(for: query)
        dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let searchController = parent as? UISearchController {
            searchController.delegate?.willDismissSearchController?(searchController)
        }
        super.dismiss(animated: flag) { [weak self] in
            if let searchController = self?.parent as? UISearchController {
                searchController.delegate?.didDismissSearchController?(searchController)
            }
            completion?()
        }
        
    }
}

extension LocationSearchResultsController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        applySnapshot(completer.results.filter({ $0.subtitle != "Search Nearby" }))
    }
}

extension LocationSearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }

}
